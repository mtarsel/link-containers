#!/bin/bash


# create the bridge, namespaces, and bridge ports for namespaces
NUMBRIDGE=2

#TODO
IP=10.0.0.1
#next_serv=$(echo $NETWORKADD | awk -F. '{printf "%d.%d.%d.%d", $1,$2,$3,$4-1}')
#outputs: 10.0.0.0

######### Create OVS switch #########
for i in `seq 1 $NUMBRIDGE`;
do
        ovs-vsctl add-br br-$i
	echo $i
       ip link set dev br-$i up
	IP=$(echo $IP | awk -F. '{printf "%d.%d.%d.%d", $1,$2+100,$3,$4}')
	echo $IP
       ifconfig br-$i $IP/24 up
done


ovs-vsctl show
