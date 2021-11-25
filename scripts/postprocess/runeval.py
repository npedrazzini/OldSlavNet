#!/usr/bin/env python3

import subprocess
import glob
import os

print('Now starting validation...')
filestobeannotated = glob.glob("../../test_data/tobeannotated/*.conllu")
goldfiles = glob.glob("../../test_data/gold/*.conllu")
outputdir = "../../test_data/annotated"

os.environ['outputdir'] = outputdir

validation_path = '{}/validation_output'.format(os.environ['MODEL_OUTDIR'])
print(validation_path)

if not os.path.exists(validation_path):
    os.mkdir(validation_path)

os.environ['validation_path'] = validation_path

for filetba in filestobeannotated:
    filename = filetba.split('/')[4]
    os.environ['filename'] = filename
    os.environ['filetba'] = filetba
    
    subprocess.call(['../postprocess/test.sh'])

annotfiles = glob.glob("../../test_data/annotated/*.conllu")
annotnames = []
for annotfile in annotfiles:
    annotname = annotfile.split('/')[4]
    annotnames.append(annotname)

for goldfile in goldfiles:
    goldname = goldfile.split('/')[4]
    if goldname in annotnames:
        os.environ['goldname'] = goldname
        subprocess.call(['../postprocess/compare-conllus.sh'])