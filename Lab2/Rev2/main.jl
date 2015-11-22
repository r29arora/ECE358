include("CSMAStructures.jl")
using DataStructures, CSMAStructures

# Command line arguments (N A P) - variable values
# Number of nodes
num_nodes = parse(Int, ARGS[1])
# Packets per second in packets per tick
arrival_rate = parse(Int, ARGS[2]) 
# Persistence paramter for P-Persistent CSMA protocols
persistence = parse(Int, ARGS[3]) 


csma = CSMA(num_nodes, arrival_rate, persistence)

@time run(csma)

