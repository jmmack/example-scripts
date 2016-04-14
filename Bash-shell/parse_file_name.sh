#Get a list of filenames from a directory
#Parse out the basename

for f in $DATA_DIR/*_R1.fastq.gz; do
  #	echo "$f"
	B=`basename $f`
  #	echo "basename: $B"
	NAME=`echo $B | cut -d "_" -f1`
  #	echo "name: $NAME"
done

#See dirname also
