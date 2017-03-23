#!/bin/bash

#Creates name spaces with ports attached to OVS. 
#Assigns an IP address to name space devices

BR=1
NUMNS=4
IP=10.0.0.0

for i in `seq 1 $NUMNS`;
do
	#create name spaces
        ip netns add ns$i

        # create a port pair. the tap$i exists in the ns, br-p$i on host 
        ip link add tap$i type veth peer name p$i
	
	#attach namespace port to OVS	
	ovs-vsctl add-port br-$BR p$i
       
	#attach namespace dev tap$i to ns1 such that tap$i exists only in ns1 
	ip link set tap$i netns ns$i

	#turn ports on in ns. execute command inside ns
        ip netns exec ns$i ip link set dev tap$i up

	#turn on port on OVS. exists on host network
        ip link set dev p$i up
        ifconfig p$i up
        
	#add ten to last octet of network ip addr
	IP=$(echo $IP | awk -F. '{printf "%d.%d.%d.%d", $1,$2,$3,$4+10}')
        
	#assign ip addresses.
        ip netns exec ns$i ifconfig tap$i $IP/24 up
done

ovs-vsctl show

