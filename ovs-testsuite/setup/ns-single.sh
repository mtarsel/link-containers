#!/bin/bash

#create name spaces
ip netns add ns1

# create a port pair. the tap1 exists in the ns, p1 on host 
ip link add tap1 type veth peer name p1
	
#attach namespace dev tap$i to ns1 such that tap$i exists only in ns1 
ip link set tap1 netns ns1

#turn ports on in ns. execute command inside ns
ip netns exec ns1 ip link set dev tap1 up

#turn on port on OVS. exists on host network
ip link set dev p1 up
        
#assign ip addresses.
ip netns exec ns1 ip add add 10.0.0.15/24 dev tap1
