#!/bin/bash

#Mick Tarsel
#remove bridge, namespace, and bridge interfaces

#NOTE - this doenst grep for anything. i just copied declarations from setup.sh
#YOUR NAMES COULD BE DIFFERENT
BRIDGE=br-01
NS1=ns1
NS2=ns2
NS3=ns3
NS4=ns4

NS1PORT=br-p1
NS2PORT=br-p2
NS3PORT=br-p3
NS4PORT=br-p4

ip netns delete $NS1
ip netns delete $NS2
ip netns delete $NS3
ip netns delete $NS4

ip link delete $NS1PORT
ip link delete $NS2PORT
ip link delete $NS3PORT
ip link delete $NS4PORT

ifconfig $BRIDGE down
ovs-vsctl del-br $BRIDGE

ovs-vsctl show

echo "all gone!!"
