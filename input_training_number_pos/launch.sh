#!/bin/bash

echo "==> Running rcSetup"
. rcSetup.sh

export PATH=./pixel-NN-training:$PATH
export NJOBS=1

set -u
set -e

BASE=$(basename $DATA_PREFIX)

echo "==> Creating inputs"
python2 pixel-NN/scripts/Run.py \
	--scandirs $DATA_PREFIX \
	--submit-dir submit_$NAME \
	--driver direct \
	--overwrite \
	--type $TYPE

if [ $TYPE = "number" ]
then
    echo "==> Balancing the dataset"
    python2 pixel-NN/scripts/balance_number.py \
	    --input submit_$NAME/data-NNinput/$BASE.root \
	    --output $BASE.$TYPE

    echo "==> Checking the balance"
    python2 pixel-NN/scripts/check_numbers.py $BASE.$TYPE.training.root
    python2 pixel-NN/scripts/check_numbers.py $BASE.$TYPE.test.root

    echo "==> Shuffling the training set"
    python2 pixel-NN/scripts/shuffle_tree.py \
	    --seed 750 \
	    --input $BASE.$TYPE.training.root \
	    --output $BASE.$TYPE.training.root_

    mv $BASE.$TYPE.training.root $BASE.$TYPE.training.noshuffle.root
    mv $BASE.$TYPE.training.root_ $BASE.$TYPE.training.root

    echo "==> Training the neural network"
    python2 ./pixel-NN-training/trainNN_keras.py \
	    --training-input $BASE.$TYPE.training.root \
	    --output $NAME \
            --config <(python2 pixel-NN-training/genconfig.py --type $TYPE) \
            --structure 25 20 \
            --output-activation sigmoid2 \
	    --l2 0.0000001 \
            --learning-rate 0.08 \
	    --momentum 0.4 \
	    --batch 60 \
	    --verbose \
	    --activation sigmoid2
else
    echo "==> Resizing the training set"
    ./RootCoreBin/bin/x86_64-slc6-gcc49-opt/resizePixelDataset \
	-n 12000000 \
	$BASE.$TYPE.training.root \
	submit_$NAME/data-NNinput/$BASE.root

    echo "==> Resizing the test set"
    ./RootCoreBin/bin/x86_64-slc6-gcc49-opt/resizePixelDataset \
	-s 12000000 \
	-n 5000000 \
	$BASE.$TYPE.test.root \
	submit_$NAME/data-NNinput/$BASE.root

    echo "==> Training the neural network"
    python2 ./pixel-NN-training/trainNN_keras.py \
	    --training-input $BASE.$TYPE.training.root \
	    --output $NAME \
	    --config <(python2 pixel-NN-training/genconfig.py --type $TYPE) \
            --structure 40 20 \
            --output-activation linear \
	    --l2 0.0000001 \
            --learning-rate 0.04 \
	    --momentum 0.3 \
	    --batch 30 \
	    --verbose \
	    --activation sigmoid2
fi

echo "==> Evaluating the test set"
python2 ./pixel-NN-training/evalNN_keras.py \
       --input $BASE.$TYPE.test.root \
       --model $NAME.model.yaml \
       --weights $NAME.weights.hdf5 \
       --config <(python2 pixel-NN-training/genconfig.py --type $TYPE) \
       --output $NAME.db \
       --normalization $NAME.normalization.txt

echo "==> Running the test driver"
test-driver $TYPE $NAME.db $NAME.root

exit 0
