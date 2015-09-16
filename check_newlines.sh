FILE=stats_tongue_buccal.txt
COUNT=$(grep -c -U $'\012' $FILE )

if [ $COUNT -eq 0 ] ; then
	echo "WARNING: Your file may not have UNIX end of lines"
elif [ $COUNT -gt 0 ] ; then
	echo "OK"
fi

#MAC: '\015\'
#DOS: '\015\012'
