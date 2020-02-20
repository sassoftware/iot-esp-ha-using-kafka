#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0


echo $1

parg1=$1
parg2=$2
outfile="/tmp/dstat_in.csv"
prefix="I,n,,"
del=","
echo "Write data to "$outfile

if [ "$parg1" == "--help" ] || [ "$parg1" == "-h" ];  then 

   echo "Usage: $0 delay iterations"
   echo "Example: $0 5 1000  == Produce 1000 lines of output 1 every 5 seconds."
   exit 1 
fi


if [ -z "$1" ] ; then  # set default delay
   parg1=5 
fi

if [ -z "$2" ] ; then  # set default iterations
   parg2=1000 
fi

rm $outfile
echo "ESP kafka input data" > $outfile


counter=1 
until [ $counter -gt $parg2 ]
do 

    usedmemory=$(vmstat -s --unit M | grep -i "used memory" | cut -f 10 -d " ")
    freememory=$(vmstat -s --unit M | grep -i "free memory" | cut -f 10 -d " ")	
    
    echo $prefix$usedmemory$del$freememory >> $outfile
    sleep $parg1
    echo -n "."
	
    ((counter++))
done 


 
