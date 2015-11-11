using DataStructures

#tick definition (1000 ticks = 1 second)
# command line arguments (N A P) - variable values
num_nodes = parse(Int, ARGS[1]) # number of nodes
arrival_rate = parse(Int, ARGS[2]) / 1000 # packets per second in packets per tick
persistence = parse(Int, ARGS[3]) # persistence paramter for P-Persistent CSMA protocols

# constant values
packet_speed = 1 / 1000 # 1 Mbps in megabits/tick
packet_length = 1.5 * 8 # 1500 bytes in Megabits 


