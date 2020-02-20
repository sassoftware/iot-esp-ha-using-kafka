#!/usr/bin/env bash 

#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

BPATH=$DFESP_HOME/bin
export TK_HOME=/opt/sas/viya/home/SASFoundation/sasexe
export LD_LIBRARY_PATH=$DFESP_HOME/lib:$TK_HOME:$DFESP_HOME/ssl/lib:$LD_LIBRARY_PATH
export PATH=$DFESP_HOME/bin:$PATH



$BPATH/dfesp_fs_adapter -C type=pub,url="dfESP://iotdemo.na.sas.com:61001/kafka1/cq1/kafka_incoming",fsname=/tmp/dstat_in.csv,fstype=csv,dateformat='%Y-%m-%d %H:%M:%S',header=2,growinginputfile=true,loglevel=trace,transport=kafka,transportconfigfile=/home/sas/kafka/kafkapub.cfg


