#!/bin/bash

#isolate VM traffic using VLANs tags

#this assumes interfaces are up and running so we dont need bridge



NUMNS=4

for i in `seq 1 $NUMNS`;
do
	#split tags into 100 and 200 from 4 ns'
	tag=$(((($i%2)+1)*100))
	
	ovs-vsctl set port p$i tag=$tag

#	ovs-vsctl add-port br-01 br-p2 tag=200
done

ovs-vsctl  show

sleep 2

#working pings
ip netns exec ns1 ping -c2 10.0.0.30
ip netns exec ns2 ping -c2 10.0.0.40

echo ""
echo "***** Below ping tests should fail. wait for it ******"
sleep 2

#this one should not work
ip netns exec ns2 ping -c1 10.0.0.30
ip netns exec ns1 ping -c1 10.0.0.40
