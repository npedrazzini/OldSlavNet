#!/bin/sh
#Usage:
#./train.sh
#
################################################################

#__DEFINE PATHS AND ADD PERMISSIONS__#

chmod -R 755 .

ROOT=./scripts/parser
decoder=$ROOT/decoder.py
mnnl=$ROOT/mnnl.py
oldslavnet=$ROOT/oldslavdep.py
parser=$ROOT/parser.py
utils=$ROOT/utils.py
runeval=./scripts/postprocess/runeval.py
testsh=./scripts/postprocess/test.sh
conlcomp=./scripts/postprocess/compare-conllus.sh
conlleval=./scripts/postprocess/conll18_ud_eval.py

source ./oldslavnet-venv/bin/activate


#__begin timer___#
START=$(date +%s)

#__define vars__#

read -p "Enter a new name for your model, no spaces (e.g.: OldSlavNet): " NEW_MODEL_NAME
NEW_MODEL_NAME=${NEW_MODEL_NAME:-nonamemodel}

mkdir ./models/$NEW_MODEL_NAME

TRAIN_DATA=../../training_data/new/train.conllu
DEV_DATA=../../training_data/new/dev.conllu
MODEL_OUTDIR=../../models/$NEW_MODEL_NAME
MODEL=model
MODELPARAMS=model.params
MODELFULLPATH=../../models/$NEW_MODEL_NAME/$MODEL
PARAMSFULLPATH=../../models/$NEW_MODEL_NAME/$MODELPARAMS

export MODEL_OUTDIR
export MODELFULLPATH
export PARAMSFULLPATH

#___DEFINE HYPERPARAMETERS___#
read -p "Enter number of training epochs (default: 30): " EPOCHS
EPOCHS=${EPOCHS:-30}

read -p "Enter number of BiLSTM dimensions (default: 128): " LSTM_DIMS
LSTM_DIMS=${LSTM_DIMS:-128}

read -p "Enter number of BiLSTM layers (default: 2): " LSTM_LAYERS
LSTM_LAYERS=${LSTML_LAYERS:-2}

read -p "Enter size of MLP hidden layer (default: 200): " HIDDEN
HIDDEN=${HIDDEN:-200}

read -p "Enter size of word embeddings (default: 100): " WEMBEDDING
WEMBEDDING=${WEMBEDDING:-100}

read -p "Enter size of character embeddings (default: 50): " CEMBEDDING
CEMBEDDING=${CEMBEDDING:-50}

read -p "Enter size of POS tag embeddings (default: 100): " PEMBEDDING
PEMBEDDING=${PEMBEDDING:-100}


#__cd to scripts__#
cd $ROOT

args=(
    --dynet-seed="123456789"
    --dynet-mem="1000"
    --epochs="$EPOCHS"
    --lstmdims="$LSTM_DIMS"
    --lstmlayers="$LSTM_LAYERS"
    --hidden="$HIDDEN"
    --wembedding="$WEMBEDDING"
    --cembedding="$CEMBEDDING"
    --pembedding="$PEMBEDDING"
    --model="$MODEL"
    --params="$MODELPARAMS"
    --outdir="$MODEL_OUTDIR"
    --train="$TRAIN_DATA"
    --dev="$DEV_DATA"
    )

#__run script with defined args__#
python3 parser.py "${args[@]}"

mkdir ../../training_data/past/$NEW_MODEL_NAME
cp ../../training_data/new/train.conllu ../../training_data/past/$NEW_MODEL_NAME/train.conllu
cp ../../training_data/new/dev.conllu ../../training_data/past/$NEW_MODEL_NAME/dev.conllu

rm ../../training_data/new/train.conllu
rm ../../training_data/new/dev.conllu

#___end timer___#
END=$(date +%s)
DIFF=$(( $END - $START ))

echo "It took $DIFF seconds to train the parser"

echo ***Training finished***

#__start validation__#

#__run eval script__#
python3 ../postprocess/runeval.py
