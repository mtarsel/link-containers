#!/bin/bash

#testing ovs extenstions of openFlow
ovs-vsctl add-br br0 -- set Bridge br0 fail-mode=secure

#setup
for i in 1 2 3 4; do
    ovs-vsctl add-port br0 p-$i
    set Interface p$i ofport_request=$i
   # ovs-ofctl mod-port br0 p$i up
done

echo "done."
