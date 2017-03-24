#!/bin/bash
# create the bridge
NUMBRIDGE=1
IP=00.0.0.1

for i in `seq 1 $NUMBRIDGE`;
do
	# Create OVS switch 
        ovs-vsctl add-br br-$i
	
	#turn the bridge on
	ip link set dev br-$i up
	
	#adds 100 to second octet in ip for different subnets
	IP=$(echo $IP | awk -F. '{printf "%d.%d.%d.%d", $1+10,$2,$3,$4}')

	#assign IP address
	ip addr add $IP/24 dev br-$i
	
	#bring the bridge interface up
	ip link set br-$i up
done

ovs-vsctl show
