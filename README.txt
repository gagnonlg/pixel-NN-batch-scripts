mkdir my_work_area && cd my_work_area
git clone ssh://git@gitlab.cern.ch:7999/lgagnon/pixel-NN-batch-scripts.git .

cd input_training_number_pos
setupATLAS
lsetup 'rcSetup Base,2.4.6'
kinit -f lgagnon@CERN.CH
git clone https://:@gitlab.cern.ch:8443/lgagnon/pixel-NN.git
git clone https://:@gitlab.cern.ch:8443/lgagnon/pixel-NN-training.git
rc find_packages
rc compile
make -C pixel-NN-training
<change data_prefix,name in submit.sh>
bash submit.sh

<in a new session>
cd input_error
setupATLAS
lsetup 'asetup 19.2.0'
kinit -f lgagnon@CERN.CH
git clone https://:@gitlab.cern.ch:8443/lgagnon/pixel-NN-training.git
make -C pixel-NN-training all TTrainedNetwork.so
<change datadir,base,jobdeps,name,nn in submit.sh>
bash submit.sh

<in a new session>
cd training_error
setupATLAS
lsetup 'rcSetup Base,2.4.6'
kinit -f lgagnon@CERN.CH
git clone https://:@gitlab.cern.ch:8443/lgagnon/pixel-NN-training.git
make -C pixel-NN-training
<change base,jobdeps,nam in submit.sh>
bash submit.sh

<To validate a network on an alternate sample>
cd eval_alternate
setupATLAS
lsetup 'rcSetup Base,2.4.6'
kinit -f lgagnon@CERN.CH
git clone https://:@gitlab.cern.ch:8443/lgagnon/pixel-NN-training.git
make -C pixel-NN-training
<change TEST_DATA, NN in submit.sh>
bash submit.sh
