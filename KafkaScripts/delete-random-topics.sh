#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0
#  
#  Delete topics that aren't listed below.
#
cd /opt/kafka/
BPATH=/opt/kafka/bin
SPATH=/opt/kafka/myscripts
echo $1

if [[ "$#" != 1  ]] ;  then 
   echo "WARNING! $0 This will delete all your topics. "
   echo "Usage: $0 now"
   exit 1 
fi

TOPICS=$(/opt/kafka/bin/kafka-topics.sh --list --zookeeper localhost:2181)

for T in $TOPICS
do 
     if [ "$T" != "__consumer_offsets" ] && \
        [ "$T" != "iotdemo.na.sas.com_61001.M" ] && \
        [ "$T" != "iotdemo.na.sas.com_61001.kafka1.cq1.kafka_incoming.I" ] && \
        [ "$T" != "iotdemo.na.sas.com_61001.kafka1.cq1.kafka_outgoing.O" ] 
       then 

        $BPATH/kafka-configs.sh --alter \
           --zookeeper localhost:2181 \
           --entity-type topics \
           --add-config retention.ms=1000 \
           --entity-name $T
	sleep 2
	$BPATH/kafka-topics.sh --delete \
            --zookeeper localhost:2181 \
            --topic $T

     fi


done 


 
