datadir=
base=$datadir/

nndir=$datadir

for typ in pos1 pos2 pos3
do
    if [ $typ = "pos1" ]; then
    	jobdep=
    elif [ $typ = "pos2" ]; then
    	jobdep=
    elif [ $typ = "pos3" ]; then
    	jobdep=
    fi
    
    for dset in training test
    do
	name=error_${typ}_${dset}
	nn=$nndir/${typ}_bischel
	echo "==> $name"
	qsub -N $name \
	     -d $PWD \
	     -j oe \
	     -v "TYPE=$typ,IN=$base.$typ.$dset.root,NN=$nn" \
	     -l nodes=atlas11.lps.umontreal.ca+atlas12.lps.umontreal.ca,nice=0 \
	     -W depend=afterok:$jobdep \
	     launch-error-input.sh

	sleep 0.5s
    done
done
	     
