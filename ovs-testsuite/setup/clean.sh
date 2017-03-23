#!/bin/bash

#Mick Tarsel
#remove bridge, namespace, and bridge interfaces

#NOTE - this doenst grep for anything. i just copied declarations from setup.sh
#YOUR NAMES COULD BE DIFFERENT
BRIDGE=1
NS=4

NS1PORT=br-p1

for i in `seq 1 $NS`;
do
	ip netns delete ns$i
done

for i in `seq 1 $BRIDGE`;
do
	ifconfig br-$i down
	ovs-vsctl del-br br-$i
done

ovs-vsctl show

echo "all gone!!"
