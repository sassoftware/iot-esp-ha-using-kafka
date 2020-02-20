#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

cd /opt/kafka/
BPATH=/opt/kafka/bin
SPATH=/opt/kafka/myscripts

$BPATH/kafka-console-consumer.sh \
--bootstrap-server iotdemo.na.sas.com:9092,iotdemo.na.sas.com:9093,iotdemo.na.sas.com:9094 \
--topic iotdemo.na.sas.com_61001.kafka1.cq1.kafka_incoming.I \
--from-beginning

 
