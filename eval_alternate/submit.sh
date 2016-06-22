launch () {
    TEST_DATA=$1
    NN=$2
    TYPE=$3

    dtype=$(python2 -c "import re; print re.match('.*s2183_([A-Za-z0-9]+)', '$TEST_DATA').group(1)")
    nntype=$(basename $NN)
    NAME=$dtype.$nntype
       
    echo "==> $NAME"
    qsub -v "NN=$NN,TEST_DATA=$TEST_DATA,TYPE=$TYPE,NAME=$NAME" \
	 -d $PWD \
	 -j oe \
	 -l nodes=atlas11.lps.umontreal.ca+atlas12.lps.umontreal.ca,nice=0 \
	 -N $NAME \
	 launch.sh
    sleep 0.5s
}

for TYPE in number pos1 pos2 pos3
do
    TEST_DATA=/lcg/storage15/atlas/gagnon/work/thresholds/2016-06-20_MC15cBLayerThresholdP1/input_training_number_pos/group.perf-idtracking.361027.Pythia8EvtGen_A14NNPDF23LO_jetjet_JZ7W.AOD_TIDE.e3668_s2608_s2183_MC15cBLayerThresholdP1_v5_EXT0.$TYPE.test.root
    NN=/lcg/storage15/atlas/gagnon/work/thresholds/2016-06-20_MC15c/input_training_number_pos/MC15c_$TYPE

    launch $TEST_DATA $NN $TYPE
done

for TYPE in error1x error1y error2x error2y error3x error3y
do
    TEST_DATA=/lcg/storage15/atlas/gagnon/work/thresholds/2016-06-20_MC15cBLayerThresholdP1/input_error/group.perf-idtracking.361027.Pythia8EvtGen_A14NNPDF23LO_jetjet_JZ7W.AOD_TIDE.e3668_s2608_s2183_MC15cBLayerThresholdP1_v5_EXT0.$(echo $TYPE | sed -e 's/x//' -e 's/y//').test.root
    NN=/lcg/storage15/atlas/gagnon/work/thresholds/2016-06-20_MC15c/training_error/$TYPE

    launch $TEST_DATA $NN $TYPE
done

    
