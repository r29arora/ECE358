using CSMAStructures

type Medium 
	line::Array
	nodes::Array
	numNodes::Int
	total_received
	function Medium(numNodes::Int, lambda)
		nodesArray = Array(Node, numNodes)
		lineArray = Array(Deque{(Int, Int, Int)}(), numNodes) # (Left, Right, Lifetime)

		for x=1:numNodes
			nodesArray[x] = Node(lambda)
		end

		fill!(lineArray,(0,0,0))

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
			currentLine::(Int, Int, Int) = medium.line[x]
			node::Node = medium.nodes[x]

			if currentLine[3] == 0 && t >= node.t_wait
				destinationIndex = destination(medium,x)
				medium.line[x] = (1,1,destinationIndex)
				medium.nodes[x].t_wait = 0
				shift!(medium.nodes[x].outputBuffer)
				# println(medium.line)
			else
				# the medium is busy, we must wait a random time
				medium.nodes[x].t_wait = t + rtime(node.lambda)
			end
		end

	end

end

function propogate(medium::Medium)
	nodeTransferArray = Array((Int, Int, Int, Int, Int, Int), medium.numNodes)
	fill!(nodeTransferArray, (0, 0, 0, 0, 0, 0))
	println("Before:", medium.line)

	for x=1:medium.numNodes
		packet::(Int, Int, Int) = medium.line[x]
		currentNode::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x]
		currentNode = (packet[1], packet[2], packet[3], 0, 0, 0)
		nodeTransferArray[x] = currentNode
	end

	println(nodeTransferArray)

	println("------")

	for x=1:medium.numNodes
		currentNode::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x]

		if x == 1
			nextNode::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x+1]
			nextNode = (nextNode[1], nextNode[2], nextNode[3], nextNode[4], nextNode[5] + currentNode[2], currentNode[3])
			nodeTransferArray[x+1] = nextNode
		elseif x == medium.numNodes
			prevNode::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x-1]
			nodeTransferArray[x-1] = (prevNode[1], prevNode[2], prevNode[3], prevNode[4] + currentNode[1], prevNode[5], prevNode[6])
		else
			prevNode2::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x-1]
			nextNode2::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x+1]
			nodeTransferArray[x-1] = (prevNode2[1], prevNode2[2], prevNode2[3], prevNode2[4] + currentNode[1], prevNode2[5], currentNode[3])
			nodeTransferArray[x+1] = (nextNode2[1], nextNode2[2], nextNode2[3], nextNode2[4], nextNode2[5] + currentNode[2], currentNode[3])
		end

		println(nodeTransferArray)

	end
	println("------")
	println(nodeTransferArray)

	for x=1:medium.numNodes
		packet::(Int, Int, Int) = medium.line[x]
		currentNode::(Int, Int, Int, Int, Int, Int) = nodeTransferArray[x]
		medium.line[x] = (currentNode[4], currentNode[5], currentNode[6])

		# if currentNode[6] == x 
		# 	medium.line[x] = (0, 0, 0) # packet reached destination
		# 	medium.total_received = medium.total_received + 1
		# else
		# 	# packet still travelling
		# end
	end
	println("After:" ,medium.line)
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