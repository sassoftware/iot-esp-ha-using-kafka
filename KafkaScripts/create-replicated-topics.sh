#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

cd /opt/kafka/
BPATH=/opt/kafka/bin
SPATH=/opt/kafka/myscripts

$BPATH/kafka-topics.sh --create \
--zookeeper localhost:2181 \
--replication-factor 3  \
--partitions 1 \
--topic iotdemo.na.sas.com_61001.M   

$BPATH/kafka-topics.sh --create \
--zookeeper localhost:2181 \
--replication-factor 3  \
--partitions 1 \
--topic iotdemo.na.sas.com_61001.kafka1.cq1.kafka_incoming.I

$BPATH/kafka-topics.sh --create \
--zookeeper localhost:2181 \
--replication-factor 3  \
--partitions 1 \
--topic iotdemo.na.sas.com_61001.kafka1.cq1.kafka_outgoing.O

$BPATH/kafka-topics.sh --create \
--zookeeper localhost:2181 \
--replication-factor 3  \
--partitions 1 \
--topic ESPAdapterMetapub

$BPATH/kafka-topics.sh --create \
--zookeeper localhost:2181 \
--replication-factor 3  \
--partitions 1 \
--topic ESPAdapterMetasub
 

 
