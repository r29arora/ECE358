include("nodeStructures.jl")
include("MediumStructures.jl")
using DataStructures, NodeStructures, MediumStructures

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
medium = Medium(3)

medium.line[1] = (1,1)
medium.line[2] = (1,1)
medium.line[3] = (1,1)

println("Before:")
println(medium.line)
propogate(medium)
println("After:")
println(medium.line)