#!/bin/bash

#Mick Tarsel
#creates an OVS bridge connected to 2 namespaces
#the namespaces are connected to bridge with veth pairs

# create the bridge, namespaces, and bridge ports for namespaces
NUMBRIDGE=1
NUMNS=2

######### Create OVS switch #########
for i in `seq 1 $NUMBRIDGE`;
do
	ovs-vsctl add-br br-$i
	ip link set dev br-$i up
	ifconfig br-$i 10.0.0.1/24 up
done


for i in `seq 1 $NUMNS`;
do
	ip netns add ns$i

done	
	# create a port pair. the tap$i exists in the ns, br-p$i on host 
#	ip link add tap$i type veth peer name br-p$i
#	ip netns exec ns$i ip link set dev tap$i up
#	ip link set dev br-p$i up 
	#assign ip addresses.
#	ifconfig br-p$ up
#	ip netns exec ns$i ifconfig tap$i 10.0.0.$i0/24 up

echo "###### List of Namespaces #####"
ip netns list
echo ""
ovs-vsctl show
echo ""
ip addr | grep br-
echo "######### finished #########"
echo "done."
