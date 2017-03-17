#!/bin/bash

#Mick Tarsel
#creates an OVS bridge connected to 2 namespaces
#the namespaces are connected to bridge with veth pairs

# create the bridge, namespaces, and bridge ports for namespaces
BRIDGE=br-01
NS1=ns1
NS2=ns2

#these ports below connect to the veth interface inside of namespace
#br-tapX devs exist on host machine
NS1PORT=br-p1 
NS2PORT=br-p2

#these devs exist INSIDE the namespace. cannot view these from host machine
NS1DEV=tap1
NS2DEV=tap2

####### Create Namespaces #######
ip netns add $NS1
ip netns add $NS2

######### Create OVS switch #########
ovs-vsctl add-br $BRIDGE
ip link set dev $BRIDGE up
ifconfig $BRIDGE 10.0.0.1/24 up

######### Config ns1 and ns2  #######
# create a port pair. the NS1DEV exists in the namespace. 
ip link add $NS1DEV type veth peer name $NS1PORT
ip link add $NS2DEV type veth peer name $NS2PORT

# attach namespace dev to namespace (removes interface from host network)
ip link set $NS1DEV netns $NS1
ip link set $NS2DEV netns $NS2

# turn on interfaces inside namespace
ip netns exec $NS1 ip link set dev $NS1DEV up
ip link set dev $NS1PORT up 

ip netns exec $NS2 ip link set dev $NS2DEV up
ip link set dev $NS2PORT up

#assign ip addresses.
ifconfig $NS1PORT up
ip netns exec $NS1 ifconfig $NS1DEV 10.0.0.20/24 up

ifconfig $NS2PORT up
ip netns exec $NS2 ifconfig $NS2DEV 10.0.0.30/24 up


echo "###### List of Namespaces #####"
ip netns list
echo ""
ovs-vsctl show
echo ""
ip addr | grep br-
echo "######### finished #########"
echo " $NS1 and $NS2 do not have ports connected to OVS"
echo "done."
