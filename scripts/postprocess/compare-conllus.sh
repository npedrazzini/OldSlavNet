#!/bin/sh

################################################################
export LANG=C.UTF-8

python3 ../postprocess/conll18_ud_eval.py -v ../../test_data/gold/$goldname ../../test_data/annotated/$goldname > $validation_path/$goldname-validated.txt