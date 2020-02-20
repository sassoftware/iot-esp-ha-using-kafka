#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

cd /opt/kafka/
gnome-terminal  --window-with-profile=zookeeper -- /opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/myscripts/zookeeper.properties

 
