#!/bin/bash

#table 0 tests
echo"" 
echo "***** no flows added"
#ovs-appctl ofproto/trace br0 in_port=1
ovs-ofctl dump-flows br0
ovs-ofctl add-flow br0 "table=0, dl_src=01:00:00:00:00:00/01:00:00:00:00:00, actions=drop"
echo ""
echo "*** flow added"
ovs-ofctl dump-flows br0


ovs-ofctl add-flow br0 "table=0, dl_dst=01:80:c2:00:00:00/ff:ff:ff:ff:ff:f0, actions=drop"
echo ""
echo "*** flow added"
ovs-ofctl dump-flows br0

ovs-ofctl add-flow br0 "table=0, priority=0, actions=resubmit(,1)"
echo ""
echo "*** flow added"
