# link-containers

Repo with some Bash scripts to create virtual networks.

# bridge-it.sh
create 2 network namespaces connect to a linux bridge without containers

              br01
             10.0.0.1
              /   \
             /      \
            /         \
     -------              ------
     |br-tap1|          |br-tap2|
    -----------         -------------
    |   tap1   |        |  tap2      |
    |namespace1| <----> | namespace2 |
    |10.0.0.20 |        | 10.0.0.30  |
    -----------         -------------

# cleanup.sh
remove namespaces and bridge from bridge-it.sh

# tunneler.sh
Link 2 containers together via a veth pair

# ovs-testsuite
Some scripts to create networks with OvS and network namespaces. Going to be a seperate repo soon.
