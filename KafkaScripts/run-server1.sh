#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

cd /opt/kafka/
BPATH=/opt/kafka/bin
SPATH=/opt/kafka/myscripts

#gnome-terminal -e "$BPATH/kafka-server-start.sh $SPATH/server1.properties" --window-with-profile=kafkabroker
gnome-terminal  --window-with-profile=kafkabroker -- $BPATH/kafka-server-start.sh $SPATH/server1.properties

 
