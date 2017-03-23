#!/bin/bash


# create the bridge, namespaces, and bridge ports for namespaces
NUMBRIDGE=1

#TODO
#NETWORKADD=10.0.0.1
#next_serv=$(echo $NETWORKADD | awk -F. '{printf "%d.%d.%d.%d", $1,$2,$3,$4-1}')
#outputs: 10.0.0.0

######### Create OVS switch #########
for i in `seq 1 $NUMBRIDGE`;
do
        ovs-vsctl add-br br-$i

       ip link set dev br-$i up
       ifconfig br-$i 10.0.0.1/24 up
done

ovs-vsctl show
