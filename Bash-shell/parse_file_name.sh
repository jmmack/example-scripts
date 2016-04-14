#Get a list of filenames from a directory
#Parse out the basename

e.g. A01_2016_R1.fastq.gz

for f in $DATA_DIR/*_R1.fastq.gz; do
  #	echo "$f"
	B=`basename $f`
  #	echo "basename: $B"
  #basename: A01_2016_R1.fastq.gz

  #Split on underscore, and get the first field
	NAME=`echo $B | cut -d "_" -f1`
  #	echo "name: $NAME"
  #name: A01
done

#See dirname also
