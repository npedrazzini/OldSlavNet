# OldSlavDep: Pre-modern Slavic dependency parser

Pre-modern Slavic dependency parser trained on a Bi-LSTM model based on [4]. The main changes to the underlying neural network model are the following:
   - ArgParse substitutes the older OptParse
   - RMSProp is used instead of Adam as an optimizer to avoid exploding gradients.
   - Initial learning rate is set to 0.1 instead of None
   
The model supersedes the previous version described in [3], which can be found in the old releases.
If you use our pretrained model to parse new pre-modern Slavic texts, please cite [1].

   1) TO BE ANNOUNCED.
   
   2) TO BE ANNOUNCED.

   3) Pedrazzini, Nilo. 2020. Exploiting Cross-Dialectal Gold Syntax for Low-Resource Historical Languages: Towards a Generic Parser for Pre-Modern Slavic. In Folgert Karsdorp, Barbara McGillivray, Adina Nerghes & Melvin Wevers (eds.), *Proceedings of the Workshop on Computational Humanities Research*, November 18–20, 2020, Amsterdam, The Netherlands (CEUR Workshop Proceedings, Vol. 2723), 237-247. http://ceur-ws.org/Vol-2723/short48.pdf.
   
   4) Nguyen, Dat Quoc & Karin Verspoor. 2018. An improved neural network model for joint POS tagging and dependency parsing. In *Proceedings of the CoNLL 2018 Shared Task: Multilingual Parsing from Raw Text to Universal Dependencies*, 81-91. (jPTDP v2.0)
   
## Model

The parser was trained on data from the Tromsø Old Russian and Old Church Slavonic Treebank (TOROT) (https://torottreebank.github.io), 20200116 release, with the exception of the Serbian data, which are from Universal Dependencies (https://github.com/UniversalDependencies/UD_Serbian-SET). Modern Russian and Serbian data were harmonized with Old East Slavic and Old Church Slavonic spelling and morphology. The harmonization scripts can be found in our Figshare repository [2]. 

Best results on test sets (described in details in paper [3]) are as follows (first three rows show the performance of the previous version of OldSlavDep:

| Model name    | Test set        | UAS   | LAS   |
| ------------- |:-------------:  | -----:| -----:|
| jPTDP-GEN     | Codex Marianus  | 83.79 | 78.42 |
| jPTDP-ESL     | PVL             | 85.70 | 80.16 |
| jPTDP-SSL     | Codex Marianus  | 83.61 | 77.98 |
| OldSlavDep v2.0     | TBD  | TBD | TBD |


## Repository breakdown
All texts (with >400 tokens) were split into train:dev:test with a 80:10:10 proportion. The folders *train*, *dev*, *test* in this repository contain these files unmerged, should one wish to experiment with different training sets by trying different combinations of data.

In the model folder (i.e. *OldSlavDep*) you can find all the relevant scripts to run the parsers on new files, as well as the training, dev and test sets used to train and evaluate the model, which is only included for the sake of transparency (i.e. you will not need them to simply use the model off-the-shelf). 

The parameters and hyperparameters files for each pretrained model (*model_NAME* and *model_NAME.params* respectively) can be found in our Figshare repository [2].

## Use the pretrained model to tag new pre-modern Slavic texts
Once you have downloaded the model folder, as well as the parameters and hyperparameters files from the Figshare repo, run the following to annotate new texts:

 ```r 
SOURCE_DIR$ python parser.py --predict --model <path-to-model_NAME> --params <path-to-model_LABEL.params> --test <path-to-input-conllu-file> --outdir <path-to-output-directory> --output <output-name.conllu>
```

`--model`: Specify path to model parameters file (model_NAME).<br/>
`--params`: Specify path to model hyper-parameters file (model_NAME.params).<br/>
`--test`: Specify path to 10-column (CoNLL-U) input file.<br/>
`--outdir`: Specify path to directory where output file will be saved.<br/>
`--output`: Specify name of the output file.<br/>
