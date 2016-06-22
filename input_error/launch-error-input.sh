. /cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/user/atlasLocalSetup.sh
. $ATLAS_LOCAL_ROOT_BASE/packageSetups/localSetup.sh 'asetup 19.2.0'

set -e

python2 ./pixel-NN-training/keras2ttrained.py \
	--model $NN.model.yaml \
	--weights $NN.weights.hdf5 \
	--normalization $NN.normalization.txt \
	--output $(basename $NN).ttrained.root

if [ $TYPE = "pos1" ]; then
   nbins=30
elif [ $TYPE = "pos2" ]; then
   nbins=25
elif [ $TYPE = "pos3" ]; then
   nbins=20
fi

output=$(basename $IN | sed 's/.pos/.error/')
python2 ./pixel-NN-training/errorNN_input.py \
	--input $IN \
	--ttrained $(basename $NN).ttrained.root \
	--output $output \
	--nbins $nbins

exit 0
