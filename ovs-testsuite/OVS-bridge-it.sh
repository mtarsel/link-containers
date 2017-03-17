#!/bin/bash

#Mick Tarsel
#creates an OVS bridge connected to 2 namespaces
#the namespaces are connected to bridge with veth pairs

# create the bridge, namespaces, and bridge ports for namespaces
BRIDGE=br01
NS1=ns1-client
NS2=ns2-server

#these ports below connect to the veth interface inside of namespace
#br-tapX devs exist on host machine
NS1PORT=br-tap1 
NS2PORT=br-tap2

#these devs exist INSIDE the namespace. cannot view these from host machine
NS1DEV=tap1
NS2DEV=tap2


# add the namespaces
ip netns add $NS1
ip netns add $NS2

ovs-vsctl add-br $BRIDGE
#brctl stp   $BRIDGE off
ip link set dev $BRIDGE up
ifconfig $BRIDGE 10.0.0.1/24 up

######### Namespace 1 #######
# create a port pair. the NS1DEV exists in the namespace. 
ip link add $NS1DEV type veth peer name $NS1PORT
# attach namespace port to linuxbridge
ovs-vsctl add-port $BRIDGE $NS1PORT 
# attach namespace dev to namespace
ip link set $NS1DEV netns $NS1
# set the ports on
ip netns exec $NS1 ip link set dev $NS1DEV up
ip link set dev $NS1PORT up 
#assign ip addresses. notice these are the same ip addresses ;)
ifconfig $NS1PORT up
ip netns exec $NS1 ifconfig $NS1DEV 10.0.0.20/24 up

######### Namespace 2 #########
# create a port pair. the dev exists in the second namespace
ip link add $NS2DEV type veth peer name $NS2PORT
# attach one side to linuxbridge
ovs-vsctl add-port $BRIDGE $NS2PORT
# attach the other side to namespace
ip link set $NS2DEV netns $NS2
# set the ports to up
ip netns exec $NS2 ip link set dev $NS2DEV up
ip link set dev $NS2PORT up
#assign ip addresses
ifconfig $NS2PORT up
ip netns exec $NS2 ifconfig $NS2DEV 10.0.0.30/24 up


echo "###### List of Namespaces #####"
ip netns list
sleep 3
echo ""
ovs-vsctl show
echo ""
echo "=====Namespace ping Test====="
ip netns exec $NS1 ping -c2 10.0.0.30
sleep 1
ip netns exec $NS2 ping -c2 10.0.0.20

echo ""
echo "done."

#unit tests
#ip netns exec ns2-server ncat -l -p 12345
#ip netns exec ns1-client python ./client.py
#tc qdisc add dev br-tap2 root netem corrupt 50%
