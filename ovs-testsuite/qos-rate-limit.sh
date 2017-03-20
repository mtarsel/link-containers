#!/bin/bash

ovs-vsctl list interface br-p1 | grep ingress

ip netns exec ns2 netserver

echo ""
echo "*******Getting baseline throughput. Should be more than 1Mbps"
ip netns exec ns1 netperf -H 10.0.0.20 -P0 -v0

#limit ns1 to 1 Mbps
ovs-vsctl set interface br-p1 ingress_policing_rate=1000
ovs-vsctl set interface br-p1 ingress_policing_burst=100

ovs-vsctl list interface br-p1 | grep ingress

#ip netns exec ns2 netserver

ps -aef | grep netserver

#ip netns exec ns1 netperf -H 10.0.0.20
#more specific
echo ""
echo "*******QoS Rate limited thruput should be less than 1 Mbps"
ip netns exec ns1 netperf -H 10.0.0.20 -P0 -v0

echo "*******changing settings back..."
ovs-vsctl set interface br-p1 ingress_policing_rate=0
ovs-vsctl set interface br-p1 ingress_policing_burst=0
ovs-vsctl list interface br-p1 | grep ingress
