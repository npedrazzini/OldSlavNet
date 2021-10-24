# OldSlavNet 
> Full documentation here: https://npedrazzini.github.io/OldSlavNet/.
> The following is only a summary.

Pre-modern Slavic neural-network dependency parser trained on a Bi-LSTM model based on [JPTDP](https://github.com/datquocnguyen/jPTDP). 

If you use our pretrained model to parse new pre-modern Slavic texts, please cite [1].
The parser supersedes the previous version described in [2], which can be downloaded from the old [releases](https://github.com/npedrazzini/OldSlavNet/releases).

## References
   
[1] Pedrazzini, Nilo & Hanne M. Eckhoff. 2021. OldSlavNet: A scalable Early Slavic dependency parser trained on modern language data. *Software Impacts* 100063.

```
@article{oldslavnet,
  title={OldSlavNet: A scalable Early Slavic dependency parser trained on modern language data},
  author={Pedrazzini, Nilo and Eckhoff, Hanne M.}, 
  journal={Software Impacts},
  pages={100063},
  year={2021},
}
```
   
[2] Pedrazzini, Nilo. 2020. Exploiting Cross-Dialectal Gold Syntax for Low-Resource Historical Languages: Towards a Generic Parser for Pre-Modern Slavic. In Folgert Karsdorp, Barbara McGillivray, Adina Nerghes & Melvin Wevers (eds.), *Proceedings of the Workshop on Computational Humanities Research*, November 18–20, 2020, Amsterdam, The Netherlands (CEUR Workshop Proceedings, Vol. 2723), 237-247. http://ceur-ws.org/Vol-2723/short48.pdf. 

```
@inproceedings{pedrazzini2020,
  title={Exploiting Cross-Dialectal Gold Syntax for Low-Resource Historical Languages: Towards a Generic Parser for Pre-Modern Slavic},
  author={Pedrazzini, Nilo}, 
  journal={CEUR Workshop Proceedings},
  volume={2723},
  pages={237--247},
  year={2020},
  url={http://ceur-ws.org/Vol-2723/short48.pdf},
}
```

## Parsing performance
Model performance on test sets is as follows:

| Model name          | Test set            | UAS   | LAS   |
| -------------       |:-------------:      | -----:| -----:|
| OldSlavNet v2.0     | Codex Marianus      | **84.12** | **78.92** |  
|   jPTDP-GEN        |                     | 83.79 | 78.42 |
| OldSlavNet v2.0     | PVL                | 85.33 | 79.66 | 
| jPTDP-ESL          |                     | **85.70** | **80.16** |
| OldSlavNet v2.0     | Vita Constantini    | **70.72** | **56.64** | 
| jPTDP-GEN       |                     | 69.23 | 56.41 |
| OldSlavNet v2.0     | Codex Suprasliensis | **74.23** | **66.51** | 
| jPTDP-GEN     |                     | 72.28 | 63.38 |
| OldSlavNet v2.0     | Sergij of Radonezh     | **74.10** | **66.11** |
|  jPTDP-GEN     |                     | 73.90 | 65.76 |

Note that the results from OldSlavNet v2.0 are from one single model, while previous results are from three different models (two variety-specific and a generic one), indicative of the greater flexibility of OldSlavNet 2.0. 

## Use the pretrained model to tag new pre-modern Slavic texts
OldSlavNet requires:
- Python 3.4+ or 2.7
- [`Dynet 2.0`](https://dynet.readthedocs.io/en/latest/python.html)

You can install the requirements by running: `pip install -r requirements.txt`

The parameters and hyperparameters of the pretrained model (*model_NAME* and *model_NAME.params*), as well as the training, development and test sets must be downloaded from the latest [release](https://github.com/npedrazzini/OldSlavNet/releases).

Run the following to annotate new texts using OldSlavNet v2.0:

 ```r 
SOURCE_DIR$ python parser.py --predict --model <path-to-model_NAME> --params <path-to-model_LABEL.params> --test <path-to-input-conllu-file> --outdir <path-to-output-directory> --output <output-name.conllu>
```

`--model`: Path to model parameters file (model_NAME).<br/>
`--params`: Path to model hyper-parameters file (model_NAME.params).<br/>
`--test`: Path to CoNLL-U input file.<br/>
`--outdir`: Path to directory where output file will be saved.<br/>
`--output`: Name of the output file.<br/>

## Update the model with new texts

If you wish to attempt improving OldSlavNet v2.0 with new early Slavic or (harmonized) modern Russian/Serbian texts, perform:

    SOURCE_DIR$ python parser.py --dynet-seed 123456789 [--dynet-mem <int>] [--epochs <int>] [--lstmdims <int>] [--lstmlayers <int>] [--hidden <int>] [--wembedding <int>] [--cembedding <int>] [--pembedding <int>] [--prevectors <path-to-pre-trained-word-embedding-file>] [--model <String>] [--params <String>] --outdir <path-to-output-directory> --train <path-to-train-file>  --dev <path-to-dev-file>
    
Hyper-parameters in [] are optional:

 * `--dynet-mem`: DyNet memory in MB.
 * `--epochs`: Training epochs. Default: 30.
 * `--lstmdims`: BiLSTM dimensions. Default: 256.
 * `--lstmlayers`: BiLSTM layers. Default: 2.
 * `--hidden`: MLP hidden layer size. Default: 200.
 * `--wembedding`: Size of word embeddings. Default: 100.
 * `--cembedding`: Size of character embeddings. Default: 50.
 * `--pembedding`: Size of POS tag embeddings. Default: 100.
 * `--prevectors`: Path to the pre-trained word embedding file for initialization. Default: None (WE are randomly initialized).
 * `--model`: Model parameters file. Default: model.
 * `--params`: Model hyper-parameters file. Default: model.params.
 * `--outdir`: Path to directory where the new trained model will be saved. 
 * `--train`: Path to training data.
 * `--dev`: Path to development data. 


**Simple example**:

    SOURCE_DIR$ python parser.py --dynet-seed 123456789 --dynet-mem 1000 --epochs 30 --lstmdims 128 --lstmlayers 2 --hidden 300 --wembedding 100 --cembedding 50 --pembedding 100 --model model --params model.params --outdir /Users/nilo/Slavic/Models --train /Models/train.conllu --dev /Models/dev.conllu 
        
This will produce (or update) the files `model` and `model.params` in folder `SOURCE_DIR/Models`. 
