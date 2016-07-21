Count the number of sequences in a gzip fastq

``
zcat my.fastq.gz | echo $((`wc -l`\4))
``
