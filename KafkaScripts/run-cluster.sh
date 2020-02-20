#Copyright © 2019, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
#SPDX-License-Identifier: Apache-2.0

./run-zookeeper.sh
sleep 9
./run-server0.sh
sleep 2
./run-server1.sh
sleep 2
./run-server2.sh

