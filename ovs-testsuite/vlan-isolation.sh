#!/bin/bash

#isolate VM traffic using VLANs tags

ovs-vsctl add-port br-01 br-p1 tag=100
ovs-vsctl add-port br-01 br-p3 tag=100

ovs-vsctl add-port br-01 br-p2 tag=200
ovs-vsctl add-port br-01 br-p4 tag=200

#working pings
ip netns exec ns1 ping -c2 10.0.0.30
ip netns exec ns2 ping -c2 10.0.0.40

echo ""
echo "***** Below ping tests should fail. wait for it ******"
sleep 2

#this one should not work
ip netns exec ns2 ping -c1 10.0.0.30
ip netns exec ns1 ping -c1 10.0.0.40
