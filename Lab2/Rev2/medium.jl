using CSMAStructures

type Medium 
	line::Array
	nodes::Array
	propBuffer::Array
	numNodes::Int
	total_received::Int
	num_collisions::Int
	function Medium(numNodes::Int, lambda::Float64)
		nodesArray = Array(Node, numNodes)
		lineArray = Array(Deque, numNodes) # (Left, Right, destinationIndex, t_transmit)
		propArray = Array(Deque, numNodes)

		for x=1:numNodes
			nodesArray[x] = Node(lambda)
			lineBuffer = Deque{(Int, Int, Int, Int)}()
			lineArray[x] = lineBuffer
			propogationBuffer = Deque{(Int, Int, Int, Int)}()
			propArray[x] = propogationBuffer
		end

		new(lineArray, nodesArray, propArray, numNodes, 0, 0)
	end
end

function destination(medium::Medium, index::Int)
	destinationIndex = rand(1:medium.numNodes)
	while destinationIndex == index
		destinationIndex = rand(1:medium.numNodes)
	end

	return destinationIndex
end

# checks the medium for every node and determines if it is okay to 
# transmit, if not, generate a random wait time for that node
function sense(medium::Medium, t, p::Int)
	for x=1:medium.numNodes
		generate(medium.nodes[x], t)
		transmit(medium.nodes[x], t)

		if !isempty(medium.nodes[x].outputBuffer)
			currentLine::Deque = medium.line[x]
			node::Node = medium.nodes[x]

			if isempty(currentLine) && t >= node.t_wait 

				pers_rand = rand(0:100)

				if p == -1 || pers_rand >= p
					destinationIndex = destination(medium,x)
					transmit_time = shift!(node.outputBuffer)
					packet1 = (1, 0, destinationIndex, transmit_time)
					packet2 = (0, 1, destinationIndex, transmit_time)
					push!(currentLine, packet1)
					push!(currentLine, packet2)
					node.t_wait = 0
					medium.total_received = medium.total_received + 1
				else 
					## defer to next tick
					node.t_wait = t + 1
				end
				# println("Sense: ", medium.line)
			else

				if length(currentLine) > 1
					# if there is more than one item in the line buffer
					# then there is a collision from the perspective of
					# the current node
					medium.num_collisions = medium.num_collisions + 1
					node.i = node.i + 1
					if node.i >= 10
						node.i = 1
					end
					random = rand(0:(2^node.i -1))
					node.t_wait = t + random
					# println("collision, t_wait = ", medium.nodes[x].t_wait, " t = ", t)
				else 
					# the medium is busy, we must wait a random time
					node.t_wait = t + rtime(node.lambda)
					# println("busy, t_wait = ", medium.nodes[x].t_wait, "t = ", t)
				end
			end

			medium.line[x] = currentLine
			medium.nodes[x] = node

		end
	end
end

function prop(medium::Medium)
	# Create a temporary storage location for the new values
	for x=1:medium.numNodes
		empty!(medium.propBuffer[x])
	end

	num_nodes = medium.numNodes

	# Propogation of packets across the medium
	for x=1:num_nodes
		currentLine::Deque = medium.line[x]
		node::Node = medium.nodes[x]
		if !isempty(currentLine)
			for y=1:length(currentLine)
				value::(Int, Int, Int, Int) = shift!(currentLine)

				if value[1] == 1
					for i=1:x
						if i !=x
							push!(medium.propBuffer[i], value)
						end
					end
				elseif value[2] == 1
					for i=x:num_nodes
						if i != x
							push!(medium.propBuffer[i], value)
						end
					end
				end
			end
		end

		medium.line[x] = currentLine
		medium.nodes[x] = node

	end

	medium.line = medium.propBuffer
	# println("Prop: ", medium.line)
end

# returns the average throughput of the medium
function averageThroughput(medium::Medium)
	# total_packets = 0
	# for x=1:medium.numNodes
	# 	total_packets = total_packets + medium.nodes[x].total_transmitted
	# end	

	average_packets_generated = medium.total_received / medium.numNodes
	packets_per_tick = average_packets_generated / num_ticks
	packets_per_second = packets_per_tick / seconds_per_tick 
	bits_per_second = packets_per_second * packet_length
	return bits_per_second / (10^6)
end