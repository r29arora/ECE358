include("nodeStructures.jl")
using DataStructures, NodeStructures

# Tick definition (1000 ticks = 1 second)
const ticks_per_sec = 1000

# Global defintion of time
t = 0

# Command line arguments (N A P) - variable values

# Number of nodes
num_nodes = parse(Int, ARGS[1])
# Packets per second in packets per tick
arrival_rate = parse(Int, ARGS[2]) / ticks_per_sec 
# Persistence paramter for P-Persistent CSMA protocols
persistence = parse(Int, ARGS[3]) 

# Constant values
packet_speed = 1 / ticks_per_sec # 1 Mbps in megabits/tick
packet_length = 1.5 * 8 # 1500 bytes in Megabits 

# Array of nodes
nodes = Array(Node, num_nodes)
fill!(nodes, Node(-1))

node = Node(-1)

for x = 0:10000
	t = t + 1.0 / ticks_per_sec
	generate(nodes[1], t)
	transmit(nodes[1], t)
end