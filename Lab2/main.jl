include("nodeStructures.jl")
using DataStructures, NodeStructures

#tick definition (1000 ticks = 1 second)
const ticks_per_sec = 1000
# command line arguments (N A P) - variable values
num_nodes = parse(Int, ARGS[1]) # number of nodes
arrival_rate = parse(Int, ARGS[2]) / ticks_per_sec 
# packets per second in packets per tick
persistence = parse(Int, ARGS[3]) 
# persistence paramter for P-Persistent CSMA protocols

# constant values
packet_speed = 1 / ticks_per_sec # 1 Mbps in megabits/tick
packet_length = 1.5 * 8 # 1500 bytes in Megabits 

#Global defintion of time
t = 0

println("Number of Nodes: ", num_nodes)
println("Arrival Rate (packets per tick): ", arrival_rate)
println("Persistence paramter: ", persistence) 


node = Node(-1)

for x = 0:10000
	t = t + 1.0 / ticks_per_sec
	generate(node, t)
	transmit(node, t)
end