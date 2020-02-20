#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

cd /opt/kafka/
BPATH=/opt/kafka/bin
SPATH=/opt/kafka/myscripts
echo $1

if [[ "$#" != 1                  ]] ;  then 
   echo "Usage: $0 topic_name"
   exit 1 
fi


$BPATH/kafka-console-consumer.sh \
--bootstrap-server iotdemo.na.sas.com:9092,iotdemo.na.sas.com:9093,iotdemo.na.sas.com:9094 \
--topic $1 \
--from-beginning

 
