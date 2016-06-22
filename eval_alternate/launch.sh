#!/bin/bash

echo "==> Running rcSetup"
. rcSetup.sh

export PATH=./pixel-NN-training:$PATH
export NJOBS=1

set -u
set -e

echo "==> Evaluating the test set"
python2 ./pixel-NN-training/evalNN_keras.py \
       --input $TEST_DATA \
       --model $NN.model.yaml \
       --weights $NN.weights.hdf5 \
       --config <(python2 pixel-NN-training/genconfig.py --type $TYPE) \
       --output $NAME.db\
       --normalization $NN.normalization.txt

echo "==> Running the test driver"
test-driver $TYPE $NAME.db $NAME.root

exit 0
