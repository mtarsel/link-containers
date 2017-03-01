#!/bin/bash

#Written by Mick Tarsel
#Purpose: links 2 docker containers together via veth pair
# Connects veth interface A with B in different container
# Connects eth0v6 and eth1v6 via IPv6

#TODO: Create the containers FIRST!! whats your docker image?
#  docker run -it --name=front_way  --net=none my-docka /bin/bash
#  docker run -it  --name=back_side --net=none my-docka /bin/bash

CLIENT=front_way
SERVER=back_side

docker start $CLIENT
docker start $SERVER

# Learn the container process IDs and create their namespace entries
fw_pid="$(docker inspect -f '{{.State.Pid}}' $CLIENT)"
echo "front_way pid:"
echo $fw_pid

bs_pid="$(docker inspect -f '{{.State.Pid}}' $SERVER)"
echo "back_side pid:"
echo $bs_pid

echo ""
echo "setting up dirs"
echo ""

#create dir to put container namespaces
if [ -d "/var/run/netns" ]; then
	echo "already have netns dir"
	echo ""
else
	sudo mkdir -p /var/run/netns
fi

sudo ln -s /proc/$fw_pid/ns/net /var/run/netns/$fw_pid
sudo ln -s /proc/$bs_pid/ns/net /var/run/netns/$bs_pid

# Create the "peer" interfaces and hand them out
sudo ip link add A type veth peer name B

sudo ip link add eth0v6 type veth peer name eth1v6

echo "setting up ipv4 client/front_way"

sudo ip link set A netns $fw_pid
sudo ip netns exec $fw_pid ip addr add 69.1.1.1/32 dev A
sudo ip netns exec $fw_pid ip link set A up
sudo ip netns exec $fw_pid ip route add 69.1.1.2/32 dev A

echo "setting up ipv4 server/back_side"
echo ""

sudo ip link set B netns $bs_pid
sudo ip netns exec $bs_pid ip addr add 69.1.1.2/32 dev B
sudo ip netns exec $bs_pid ip link set B up
sudo ip netns exec $bs_pid ip route add 69.1.1.1/32 dev B

echo "front_way ipv6 set up"
echo ""
sudo ip link set eth0v6  netns $fw_pid
sudo ip netns exec $fw_pid ip -6 addr add 2001:0db8:0:f101::1/64 dev eth0v6
sudo ip netns exec $fw_pid ip link set eth0v6 up
sudo ip netns exec $fw_pid ip route add 2001:0db8:0:f101::2 dev eth0v6

echo "back_side ipv6 set up"
echo ""

sudo ip link set eth1v6  netns $bs_pid
sudo ip netns exec $bs_pid ip -6 addr add 2001:0db8:0:f101::2/64 dev eth1v6
sudo ip netns exec $bs_pid ip link set eth1v6 up
sudo ip netns exec $bs_pid ip route add 2001:0db8:0:f101::1/64 dev eth1v6

echo ""
echo "done."
