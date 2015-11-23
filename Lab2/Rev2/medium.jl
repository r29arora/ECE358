using CSMAStructures

type Medium 
	line::Array
	nodes::Array
	numNodes::Int
	total_received::Int
	num_collisions::Int
	packets_dropped::Int
	function Medium(numNodes::Int, lambda::Float64)
		new(lineArray, nodesArray, numNodes, 0, 0, 0)
	end
end

# Given the index of the current node, generate a random number
# that determines the final destination index
function destination(medium::Medium, index::Int)
	destinationIndex = rand(1:medium.numNodes)
	while destinationIndex == index
		destinationIndex = rand(1:medium.numNodes)
	end

	return destinationIndex
end


# returns the average throughput of the medium
function averageThroughput(medium::Medium)
	average_packets_generated = medium.total_received / medium.numNodes
	packets_per_tick = average_packets_generated / num_ticks
	packets_per_second = packets_per_tick / seconds_per_tick 
	bits_per_second = packets_per_second * packet_length
	return bits_per_second / (10^6)
end