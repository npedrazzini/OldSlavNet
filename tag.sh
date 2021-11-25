#!/bin/sh
#Usage:
#./tag.sh
#
################################################################

#__DEFINE PATHS AND ADD PERMISSIONS__#
chmod -R 755 .

ROOT=./scripts/parser
converter=$ROOT/converter.py
decoder=$ROOT/decoder.py
mnnl=$ROOT/mnnl.py
oldslavnet=$ROOT/oldslavdep.py
parser=$ROOT/parser.py
utils=$ROOT/utils.py

source ./oldslavnet-venv/bin/activate

#__begin timer___#
START=$(date +%s)

#__define vars__#

read -p "Enter name of the model you want to parse your text with (default: OldSlavNet): " directme
directme=${directme:-OldSlavNet}

read -p "Enter name of the file to be annotated (press Enter for 'all'): " test_name
test_name=${test_name:-all}

PATH_TO_MODEL=../../models/$directme/model
PATH_TO_PARAMS=../../models/$directme/model.params
TESTDIR=../../test_data/tobeannotated
OUTDIR=../../test_data/annotated

cd $ROOT

if [ "$test_name" == "all" ]
then
    for filename in /$TESTDIR/*.conllu;
    do
        TEST_SET=$filename
        OUTFILE=$(basename $filename)
        args=(
            --predict
            --model="$PATH_TO_MODEL"
            --params="$PATH_TO_PARAMS"
            --test="$TEST_SET"
            --outdir="$OUTDIR"
            --output="$OUTFILE"
            )
        python3 parser.py "${args[@]}"
    done
else
    TEST_SET=$TESTDIR/$test_name
    OUTFILE=$test_name
#__cd to scripts__#
    args=(
        --predict
        --model="$PATH_TO_MODEL"
        --params="$PATH_TO_PARAMS"
        --test="$TEST_SET"
        --outdir="$OUTDIR"
        --output="$OUTFILE"
        )
    python3 parser.py "${args[@]}"
fi
#___end timer___#
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"

echo ***Progam end***