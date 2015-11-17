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
lambda = convert(Int,arrival_rate * ticks_per_sec)

# Array of nodes
medium = Medium(num_nodes, lambda)

total_sent = 0
total_generated_packets = 0

function print_check(medium::Medium)
	print("   ")
	for y = 1:num_nodes
		print(medium.nodes[y].check, "     ")
	end

	print("\n")
end

num_ticks = 10000000

for x = 1:num_ticks
	t = t + prop_delay
	for y = 1:num_nodes
		result = generate(medium.nodes[y], t)

		if result != -1
			total_generated_packets = total_generated_packets + 1
		end
	end
	# print_check(medium)
	propogate(medium)
	# print_check(medium)
	sense(medium,t)

	for y=1:num_nodes
		if medium.nodes[y].backoffCounter > 0
			medium.nodes[y].backoffCounter = medium.nodes[y].backoffCounter - 1
		end

		if medium.nodes[y].check > 0 
			if medium.nodes[y].check == 1 # value is being decremented from 1 to 0 with no collision => successful transfer
				total_sent = total_sent + 1
			end

			medium.nodes[y].check = medium.nodes[y].check - 1		
		end
	end
end

println("total_sent = ", total_sent)
println("total_generated = ",total_generated_packets)

data = total_sent * 1.5 * 8 # 1 Packet = 1.5 * 8 Kilobits per second
time = num_ticks * prop_delay # Number of ticks * (seconds / ticks) = number of seconds run

throughput = data / time
println("throughput (kbps) = ", throughput)
