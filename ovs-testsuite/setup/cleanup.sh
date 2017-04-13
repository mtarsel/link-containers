#!/bin/bash

BRIDGE=$1

#delete all name spaces
ip -all netns delete

#delete all bridges
for i in `seq 1 $BRIDGE`;
do
    ip link set br-$i down
    ovs-vsctl del-br br-$i
done

ovs-vsctl show 
