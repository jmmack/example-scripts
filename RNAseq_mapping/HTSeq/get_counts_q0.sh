#18Sept2015
#Jean Macklaim
WORKING_DIR=/Volumes/data/A_n_L/sept2015


for f in *_maize.sam; do
	NAME=`echo $f | cut -d "_" -f1`
#	echo "name: $NAME"

#	echo "# Running $NAME"
	nohup htseq-count ${NAME}_maize.sam ../reference_sequences/genes_htseq.gff -t gene -a 0 > out_${NAME}_q0.txt 2>&1&
done

#wait for these ^ processes to finish
wait


for f in out_*_q0.txt; do
	NAME=`echo $f | cut -d "_" -f2`

#get the assignment information
	echo "# Sample $NAME" >> q0_summary.txt
	grep "__" out_${NAME}_q0.txt >> q0_summary.txt

#get the counts tables per sample
	grep "^gene" out_${NAME}_q0.txt > ${NAME}_counts_q0.txt

	# tail -n 5 out_${NAME}_q0.txt > ${NAME}_counts_report_q0.txt
#remove these when done
#	rm out_${NAME}_q0.txt
done
