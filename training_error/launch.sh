# Script for batch submission
# e.g.
# qsub -v "NAME=test,TRAINING=train.root,TEST=test.root,TYPE=pos1,SIZEX=7,SIZEY=7" -N test -d $PWD -j oe launch.sh

. rcSetup.sh

export PATH=./pixel-NN-training:$PATH
export NJOBS=1

set -u
set -e

python2 ./pixel-NN-training/trainNN_keras.py \
	    --training-input $TRAINING \
	    --output $NAME \
	    --config <(python2 pixel-NN-training/genconfig.py --type $TYPE | tee config.txt) \
	    --structure 15 10 \
	    --output-activation sigmoid2 \
	    --l2 0.000001 \
	    --learning-rate 0.3 \
	    --momentum 0.7 \
	    --batch 50 \
	    --verbose \
	    --activation sigmoid2

python2 ./pixel-NN-training/evalNN_keras.py \
       --input $TEST \
       --model $NAME.model.yaml \
       --weights $NAME.weights.hdf5 \
       --config <(python2 pixel-NN-training/genconfig.py --type $TYPE) \
       --output $NAME.db \
       --normalization $NAME.normalization.txt

test-driver $TYPE $NAME.db $NAME.root

