data_prefix=/lcg/storage15/atlas/gagnon/data/

for typ in number pos1 pos2 pos3
do
	   type=$typ
	   name=${typ}_
	   echo "bash launch.sh |& tee $PWD/$name.LOG" \
	       | qsub -v "NAME=$name,DATA_PREFIX=$data_prefix,TYPE=$type" \
		      -N $name \
		      -d $PWD \
		      -l nice=0,nodes=atlas11.lps.umontreal.ca+atlas12.lps.umontreal.ca \
		      -j oe
	
	   sleep 0.5s
done
