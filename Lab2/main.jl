include("nodeStructures.jl")
include("MediumStructures.jl")
using DataStructures, NodeStructures, MediumStructures

# Tick definition (1000 ticks = 1 second)
const speed_of_light = 3*(10^8)
const prop_delay = 10 / ((2/3)*speed_of_light)
const ticks_per_sec = 1 / prop_delay

# Global defintion of time
t = 0

# Command line arguments (N A P) - variable values

# Number of nodes
num_nodes = parse(Int, ARGS[1])
# Packets per second in packets per tick
arrival_rate = parse(Int, ARGS[2]) 
# Persistence paramter for P-Persistent CSMA protocols
persistence = parse(Int, ARGS[3]) 
# Lambda - used for generating packets on every node
lambda = convert(Int,arrival_rate * ticks_per_sec / 10)

# Array of nodes
medium = Medium(num_nodes, lambda)

for x = 1:1000
	t = t + prop_delay
	for y = 1:num_nodes
		generate(medium.nodes[y], t)
	end

	propogate(medium)
	sense(medium,t)
	println(medium.line)
end

