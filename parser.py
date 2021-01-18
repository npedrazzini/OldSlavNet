# coding=utf-8
from __future__ import absolute_import, division, print_function, unicode_literals
from builtins import str
from io import open

from argparse import ArgumentParser
import pickle, utils, oldslavdep, os, os.path, time

if __name__ == '__main__':

    parser = ArgumentParser() #changed from OptParse to ArgParse (NP)
    parser.add_argument("--train", dest="conll_train", help="Path to annotated CONLL train file", metavar="FILE", default="N/A")
    parser.add_argument("--dev", dest="conll_dev", help="Path to annotated CONLL dev file", metavar="FILE", default="N/A")
    parser.add_argument("--test", dest="conll_test", help="Path to CONLL test file", metavar="FILE", default="N/A")
    parser.add_argument("--output", dest="conll_test_output", help="File name for predicted output", metavar="FILE", default="N/A")
    parser.add_argument("--prevectors", dest="external_embedding", help="Pre-trained vector embeddings", metavar="FILE")
    parser.add_argument("--params", dest="params", help="Parameters file", metavar="FILE", default="model.params")
    parser.add_argument("--model", dest="model", help="Load/Save model file", metavar="FILE", default="model")
    parser.add_argument("--wembedding", type=int, dest="wembedding_dims", default=100)
    parser.add_argument("--cembedding", type=int, dest="cembedding_dims", default=50)
    parser.add_argument("--pembedding", type=int, dest="pembedding_dims", default=100)
    parser.add_argument("--epochs", type=int, dest="epochs", default=30)
    parser.add_argument("--hidden", type=int, dest="hidden_units", default=100)
    parser.add_argument("--lr", type=float, dest="learning_rate", default=0.1) #changed from None to 0.1 and uncommented (NP)
    parser.add_argument("--outdir", type=str, dest="output", default="results")
    parser.add_argument("--activation", type=str, dest="activation", default="tanh")
    parser.add_argument("--lstmlayers", type=int, dest="lstm_layers", default=2)
    parser.add_argument("--lstmdims", type=int, dest="lstm_dims", default=128)
    parser.add_argument("--disableblstm", action="store_false", dest="blstmFlag", default=True)
    parser.add_argument("--disablelabels", action="store_false", dest="labelsFlag", default=True)
    parser.add_argument("--predict", action="store_true", dest="predictFlag", default=False)
    parser.add_argument("--bibi-lstm", action="store_false", dest="bibiFlag", default=True)
    parser.add_argument("--disablecostaug", action="store_false", dest="costaugFlag", default=True)
    parser.add_argument("--dynet-seed", type=int, dest="seed", default=0) #changed from 0 to 7 (NP)
    parser.add_argument("--dynet-mem", type=int, dest="mem", default=0)

    args = parser.parse_args()

    #print 'Using external embedding:', args.external_embedding

    if args.predictFlag:
        with open(args.params, 'rb') as paramsfp:
            words, w2i, c2i, pos, rels, stored_opt = pickle.load(paramsfp)
        stored_opt.external_embedding = None
        print('Loading pre-trained model')
        parser = oldslavdep.OldSlavDep(words, pos, rels, w2i, c2i, stored_opt)
        parser.Load(args.model)
        
        testoutpath = os.path.join(args.output, args.conll_test_output)
        print('Predicting POS tags and parsing dependencies')
        # ts = time.time()
        # test_pred = list(parser.Predict(options.conll_test))
        # te = time.time()
        # print 'Finished in', te-ts, 'seconds.'
        # utils.write_conll(testoutpath, test_pred)

        with open(testoutpath, 'w') as fh:
            for sentence in parser.Predict(args.conll_test):
                for entry in sentence[1:]:
                    fh.write(str(entry) + '\n')
                fh.write('\n')

    else:
        print("Training file: " + args.conll_train)
        if args.conll_dev != "N/A":
            print("Development file: " + args.conll_dev)

        highestScore = 0.0
        eId = 0

        if os.path.isfile(os.path.join(args.output, args.params)) and \
                os.path.isfile(os.path.join(args.output, os.path.basename(args.model))) :

            print('Found a previous saved model => Loading this model')
            with open(os.path.join(args.output, args.params), 'rb') as paramsfp:
                words, w2i, c2i, pos, rels, stored_opt = pickle.load(paramsfp)
            stored_opt.external_embedding = None
            parser = oldslavdep.OldSlavDep(words, pos, rels, w2i, c2i, stored_opt)
            parser.Load(os.path.join(args.output, os.path.basename(args.model)))
            parser.trainer.restart()
            if args.conll_dev != "N/A":
                devPredSents = parser.Predict(args.conll_dev)

                count = 0
                lasCount = 0
                uasCount = 0
                posCount = 0
                poslasCount = 0
                for idSent, devSent in enumerate(devPredSents):
                    conll_devSent = [entry for entry in devSent if isinstance(entry, utils.ConllEntry)]

                    for entry in conll_devSent:
                        if entry.id <= 0:
                            continue
                        if entry.pos == entry.pred_pos and entry.parent_id == entry.pred_parent_id and entry.pred_relation == entry.relation:
                            poslasCount += 1
                        if entry.pos == entry.pred_pos:
                            posCount += 1
                        if entry.parent_id == entry.pred_parent_id and entry.pred_relation == entry.relation:
                            lasCount += 1
                        if entry.parent_id == entry.pred_parent_id:
                            uasCount += 1
                        count += 1

                print("---\nLAS accuracy:\t%.2f" % (lasCount * 100 / count))
                print("UAS accuracy:\t%.2f" % (uasCount * 100 / count))
                print("POS accuracy:\t%.2f" % (posCount * 100 / count))
                print("POS&LAS:\t%.2f" % (poslasCount * 100 / count))

                score = poslasCount * 100 / count
                if score >= highestScore:
                    parser.Save(os.path.join(args.output, os.path.basename(args.model)))
                    highestScore = score

                print("POS&LAS of the previous saved model: %.2f" % (highestScore))

        else:
            print('Extracting vocabulary')
            words, w2i, c2i, pos, rels = utils.vocab(args.conll_train)

            with open(os.path.join(args.output, args.params), 'wb') as paramsfp:
                pickle.dump((words, w2i, c2i, pos, rels, args), paramsfp, protocol=2)

            #print 'Initializing joint model'
            parser = oldslavdep.OldSlavDep(words, pos, rels, w2i, c2i, args)
        

        for epoch in range(args.epochs):
            print('\n-----------------\nStarting epoch', epoch + 1)

            if epoch % 10 == 0:
                if epoch == 0:
                    parser.trainer.restart(learning_rate=0.001) 
                elif epoch == 10:
                    parser.trainer.restart(learning_rate=0.0005)
                else:
                    parser.trainer.restart(learning_rate=0.00025)

            parser.Train(args.conll_train)
            
            if args.conll_dev == "N/A":
                parser.Save(os.path.join(args.output, os.path.basename(args.model)))
                
            else: 
                devPredSents = parser.Predict(args.conll_dev)
                
                count = 0
                lasCount = 0
                uasCount = 0
                posCount = 0
                poslasCount = 0
                for idSent, devSent in enumerate(devPredSents):
                    conll_devSent = [entry for entry in devSent if isinstance(entry, utils.ConllEntry)]
                    
                    for entry in conll_devSent:
                        if entry.id <= 0:
                            continue
                        if entry.pos == entry.pred_pos and entry.parent_id == entry.pred_parent_id and entry.pred_relation == entry.relation:
                            poslasCount += 1
                        if entry.pos == entry.pred_pos:
                            posCount += 1
                        if entry.parent_id == entry.pred_parent_id and entry.pred_relation == entry.relation:
                            lasCount += 1
                        if entry.parent_id == entry.pred_parent_id:
                            uasCount += 1
                        count += 1
                        
                print("---\nLAS accuracy:\t%.2f" % (lasCount * 100 / count))
                print("UAS accuracy:\t%.2f" % (uasCount * 100 / count))
                print("POS accuracy:\t%.2f" % (posCount * 100 / count))
                print("POS&LAS:\t%.2f" % (poslasCount * 100 / count))
                
                score = poslasCount * 100 / count
                if score >= highestScore:
                    parser.Save(os.path.join(args.output, os.path.basename(args.model)))
                    highestScore = score
                    eId = epoch + 1
                
                print("Highest POS&LAS: %.2f at epoch %d" % (highestScore, eId))

