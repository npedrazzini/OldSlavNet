# Neural-network parsers for Early Slavic

Early Slavic dependency parsers trained on the Bi-LSTM model by [2] (https://github.com/datquocnguyen/jPTDP).

If you use any of the pretrained models here presented to tag new Early Slavic texts, please cite both [1], where the training of the parsers and their performance are discussed, and [2], the latest publication by the original authors of jPTDP:

   1) Pedrazzini, Nilo. 2020. Exploiting Cross-Dialectal Gold Syntax for Low-Resource Historical Languages: Towards a Generic Parser for Pre-Modern Slavic. In Folgert Karsdorp, Barbara McGillivray, Adina Nerghes & Melvin Wevers (eds.), *Proceedings of the Workshop on Computational Humanities Research*, November 18–20, 2020, Amsterdam, The Netherlands (CEUR Workshop Proceedings, Vol. 2723), 237-247. http://ceur-ws.org/Vol-2723/short48.pdfForthcoming.
   
   2) Nguyen, Dat Quoc & Karin Verspoor. 2018. An improved neural network model for joint POS tagging and dependency parsing. In *Proceedings of the CoNLL 2018 Shared Task: Multilingual Parsing from Raw Text to Universal Dependencies*, 81-91. (jPTDP v2.0)
   
## Models

There are three pretrained models:
- *jPTDP-GEN*: A generic parser for early Slavic, trained on both South and East Slavic data.
- *jPTDP-ESL*: A specialized parser for early East Slavic, trained on Old East Slavic and Middle Russian data.
- *jPTDP-SSL*: A specialized parser for early South Slavic, trained on Old Church Slavonic and later Church Slavonic data.

Best results on test sets (as detailed in paper [1]) are as follows:

| Model name    | Test set        | UAS   | LAS   |
| ------------- |:-------------:  | -----:| -----:|
| jPTDP-GEN     | Codex Marianus  | 83.79 | 78.42 |
| jPTDP-ESL     | PVL             | 85.70 | 80.16 |
| jPTDP-SSL     | Codex Marianus  | 83.61 | 77.98 |

All models were trained on data from the Tromsø Old Russian and Old Church Slavonic Treebank (TOROT) (https://torottreebank.github.io), 20200116 release. 

## Repository breakdown
All texts (with >400 tokens) were split into train:dev:test with a 80:10:10 proportion. The folders *train*, *dev*, *test* in this repository contain these files unmerged, should one wish to experiment with different training sets by trying different combinations of data.

In the models folders (i.e. *jPTDP-GEN*, *jPTDP-ESL* or *jPTDP-SSL*) you can find all the relevant scripts to run the parsers on new files, as well as the training, dev and test sets used in [1] to train and evaluate each model, which are only included for the sake of transparency (i.e. you will not need them to simply use these models off-the-shelf). 

The parameters and hyperparameters files for each pretrained model (*model_NAME* and *model_NAME.params* respectively) need to be downloaded from https://doi.org/10.6084/m9.figshare.12950093.v1. In order to tag a new text with one of the pretrained models, choose the right parameters and hyperparameters files from the Figshare repo, depending on the model that you deem most fitting for your data. E.g. if the dataset to be annotated is an East Slavic text, you might want to use either the generic model or the specialized East Slavic model. For the former, you will need the files *model_GEN* and *model_GEN.params*, for the latter *model_ESL* and *model_ESL.params*. Likewise, to use the specialized South Slavic model, you will need the files *model_SSL* and *model_SSL.params*.

## Use a pretrained model to tag new early Slavic texts
Once you have downloaded the relevant model folder for your data (i.e. *jPTDP-GEN*, *jPTDP-ESL* or *jPTDP-SSL*), as well as the right parameters and hyperparameters files from the Figshare repo, run the following to annotate new texts:

 ```r 
SOURCE_DIR$ python jPTDP.py --predict --model <path-to-model_NAME> --params <path-to-model_LABEL.params> --test <path-to-input-conllu-file> --outdir <path-to-output-directory> --output <output-name.conllu>
```

`--model`: Specify path to model parameters file (model_NAME).<br/>
`--params`: Specify path to model hyper-parameters file (model_NAME.params).<br/>
`--test`: Specify path to 10-column (CoNLL-U) input file.<br/>
`--outdir`: Specify path to directory where output file will be saved.<br/>
`--output`: Specify name of the output file.<br/>
