#!/bin/bash

BR=1
#NUMBRIDGE=$1
NUMNS=4
IP=10.0.0.0

for i in `seq 1 $NUMNS`;
do
        ip netns add ns$i
#	ovs-vsctl add-port br-$NUMBRIDGE p$i

        # create a port pair. the tap$i exists in the ns, br-p$i on host 
        ip link add tap$i type veth peer name p$i
        ip link set tap$i netns ns$i
        ip netns exec ns$i ip link set dev tap$i up
        ip link set dev p$i up
	ovs-vsctl add-port br-$BR p$i
        
        #assign ip addresses.
        ifconfig p$i up
	#add ten to last octet of network ip addr
	IP=$(echo $IP | awk -F. '{printf "%d.%d.%d.%d", $1,$2,$3,$4+10}')
	#echo $IP
        ip netns exec ns$i ifconfig tap$i $IP/24 up
done

