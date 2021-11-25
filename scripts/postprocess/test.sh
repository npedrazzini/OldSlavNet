#!/bin/sh

################################################################

#__DEFINE PATHS AND ADD PERMISSIONS__#

#__begin timer___#
echo ***Now annotating $filetba***

START=$(date +%s)

#__cd to scripts__#

args=(
    --predict
    --model="$MODELFULLPATH"
    --params="$PARAMSFULLPATH"
    --test="$filetba"
    --outdir="$outputdir"
    --output="$filename"
    )

python3 parser.py "${args[@]}"

#___end timer___#
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
