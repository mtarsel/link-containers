#!/bin/bash

#Mick Tarsel
#remove bridge, namespace, and bridge interfaces

#NOTE - this doenst grep for anything. i just copied declarations from setup.sh
#YOUR NAMES COULD BE DIFFERENT
BRIDGE=br01
NS1=ns1-client
NS2=ns2-server
NS1PORT=br-tap1
NS2PORT=br-tap2

ip netns delete $NS1
ip netns delete $NS2
ip link delete $NS1PORT
ip link delete $NS2PORT
ifconfig $BRIDGE down
ovs-vsctl del-br $BRIDGE

ovs-vsctl show

echo "all gone!!"

ip addr
