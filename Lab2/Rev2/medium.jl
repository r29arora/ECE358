using CSMAStructures

type Medium 
	line::Array
	nodes::Array
	numNodes::Int
	total_received
	function Medium(numNodes::Int, lambda)
		nodesArray = Array(Node, numNodes)
		lineArray = Array(Any, numNodes) # (Left, Right, Lifetime)

		for x=1:numNodes
			nodesArray[x] = Node(lambda)
			lineBuffer = Deque{(Int, Int, Int)}()
			lineArray[x] = lineBuffer
		end

		new(lineArray, nodesArray, numNodes, 0)
	end
end

function destination(medium::Medium, index)
	destinationIndex = rand(1:medium.numNodes)
	while destinationIndex != index
		destinationIndex = rand(1:medium.numNodes)
	end

	return destinationIndex
end

# checks the medium for every node and determines if it is okay to 
# transmit, if not, generate a random wait time for that node
function sense(medium::Medium, t)
	for x=1:medium.numNodes
		generate(medium.nodes[x], t)
		transmit(medium.nodes[x], t)

		if !isempty(medium.nodes[x].outputBuffer)
			currentLine::Deque = medium.line[x]
			node::Node = medium.nodes[x]

			if isempty(currentLine)
				destinationIndex = destination(medium,x)
				packet1 = (1, 0, destinationIndex)
				packet2 = (0, 1, destinationIndex)
				push!(medium.line[x], packet1)
				push!(medium.line[x], packet2)
				# medium.nodes[x].t_wait = 0
				shift!(medium.nodes[x].outputBuffer)
				# println("Sense: ", medium.line)
			else
				# the medium is busy, we must wait a random time
				# medium.nodes[x].t_wait = t + rtime(node.lambda)
			end
		end
	end
end

function prop(medium::Medium)
	# propBuffer = Array(Any, medium.numNodes)

	# # Create a temporary storage location for the new values
	# for x=1:medium.numNodes
	# 	propIndex = Deque{(Int, Int, Int)}()
	# 	propBuffer[x] = propIndex
	# end

	# for x=1:medium.numNodes	
	# 	currentNodeLine::Deque = medium.line[x]

	# 	if !isempty(currentNodeLine)
	# 		for y=1:length(currentNodeLine)
	# 			value::(Int, Int, Int) = shift!(currentNodeLine)

	# 			if value[1] == 1

	# 				if y != 1
	# 					for i=1:(value[3]-1)
	# 						push!(propBuffer[i], value)
	# 					end
	# 				end	

	# 			elseif value[2] == 1
	# 				if y != medium.numNodes
	# 					for i=(value[3]+1):medium.numNodes
	# 						push!(propBuffer[i], value)
	# 					end
	# 				end
	# 			end


	# 		end
	# 	end


	# end

	# medium.line = propBuffer
	# println("Prop: ", medium.line)

	for x=1:medium.numNodes
		if !isempty(medium.line[x])
			shift!(medium.line[x])
			shift!(medium.line[x])
		end
	end

end

# returns the average throughput of the medium
function averageThroughput(medium::Medium)
	total_packets = 0
	for x=1:medium.numNodes
		total_packets = total_packets + medium.nodes[x].total_transmitted
	end	

	average_packets_generated = total_packets / medium.numNodes
	packets_per_tick = average_packets_generated / num_ticks
	packets_per_second = packets_per_tick / seconds_per_tick 
	bits_per_second = packets_per_second * packet_length
	return bits_per_second / (10^6)
end