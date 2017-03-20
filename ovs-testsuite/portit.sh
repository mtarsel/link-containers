#!/bin/bash

ovs-vsctl add-port br-01 br-p1 
ovs-vsctl add-port br-01 br-p3 

ovs-vsctl add-port br-01 br-p2 
ovs-vsctl add-port br-01 br-p4 

ovs-vsctl show

echo "done"
