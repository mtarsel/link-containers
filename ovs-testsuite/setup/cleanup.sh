#!/bin/bash

BRIDGE=1
NS=$(ip netns list | wc -l)

#delete all name spaces
for i in `seq 1 $NS`;
do
    ip netns delete ns$i
done

#delete all bridges
for i in `seq 1 $BRIDGE`;
do
    ifconfig br-$i down
    ovs-vsctl del-br br-$i
done
