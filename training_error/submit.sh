base=
for dir in x y
do
    for n in 1 2 3
    do
	name=error${n}${dir}
	training=$base.error$n.training.root
	test=$base.error$n.test.root
	type=$name

	if  [ $n -eq 1 ]; then
	    jobdep=
	elif [ $n -eq 2 ]; then
	    jobdep=
	elif [ $n -eq 3 ]; then
	    jobdep=
	fi

	echo "=> $name"

	qsub -v "NAME=$name,TRAINING=$training,TEST=$test,TYPE=$type,SIZEX=7,SIZEY=7" \
	     -d $PWD \
	     -j oe \
	     -l nodes=atlas11.lps.umontreal.ca+atlas12.lps.umontreal.ca,nice=0 \
	     -W depend=afterok:$jobdep \
	     -N $name \
	     launch.sh

	sleep 0.5s

    done
done

	
