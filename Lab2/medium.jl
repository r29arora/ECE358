using DataStructures, NodeStructures

# medium.line represents an array of packets of type (Int, Int, Int)
# this represents (# nodes Left, # nodes Right, how long it should detect a collision)


type Medium
	line::Array
	nodes::Array
	numNodes::Int
	function Medium(numNodes::Int, lambda)
		array = Array(Node, numNodes)
		
		for x = 1:numNodes
			array[x] = Node(-1, lambda)
		end

		line = Array((Int, Int), numNodes)
		fill!(line, (0,0))

		new(line, array, numNodes)
	end
end

function destination(medium::Medium, index::Int)
	randomDestination = rand(1:medium.numNodes)

	while randomDestination == index
		randomDestination = rand(1:medium.numNodes)
	end
	if randomDestination > index 
		randomDestination = randomDestination - index
	else
		randomDestination = index - randomDestination
	end
	
	return randomDestination
end

function sense(medium::Medium, t)
	# println("sense medium:")
	for x = 1:medium.numNodes
		result = transmit(medium.nodes[x], t)
		if result != -1 && medium.nodes[x].check == 0
			packet = medium.line[x]
			if packet[1] > 0 || packet[2]  > 0 
				medium.nodes[x].t_transmit = medium.nodes[x].t_transmit + rtime(medium.nodes[x])
			else
				destinationIndex = destination(medium, x)
				medium.nodes[x].check = destinationIndex # Destination Counter
				medium.line[x] = (packet[1] + 1, packet[2] + 1)
			end
		end
	end

	# println(medium.line)

end

function propogate(medium::Medium)
	# println("Propogate:")

	nodeTransferArray = Array((Int, Int, Int, Int), medium.numNodes)
	fill!(nodeTransferArray, (0, 0, 0, 0))

	for x = 1:medium.numNodes
		packet::(Int, Int) = medium.line[x]
		currentNode::(Int, Int, Int, Int) = nodeTransferArray[x]
		currentNode = (packet[1], packet[2], 0, 0)
		nodeTransferArray[x] = currentNode
	end

	for x = 1:medium.numNodes
		currentNode::(Int, Int, Int, Int) = nodeTransferArray[x]

		if x == 1 
			nextNode::(Int, Int, Int, Int) = nodeTransferArray[x+1]
			nextNode = (nextNode[1], nextNode[2], nextNode[4], nextNode[4] + currentNode[2])
			nodeTransferArray[x+1] = nextNode
		elseif x == medium.numNodes
			prevNode::(Int, Int, Int, Int) = nodeTransferArray[x-1]
			prevNode = (prevNode[1], prevNode[2], prevNode[3]+currentNode[1],prevNode[4])
			nodeTransferArray[x-1] = prevNode
		else
			prevNode2::(Int, Int, Int, Int) = nodeTransferArray[x-1]
			nextNode2::(Int, Int, Int, Int) = nodeTransferArray[x+1]
			prevNode2 = (prevNode2[1], prevNode2[2], prevNode2[3]+currentNode[1],prevNode2[4])
			nextNode2 = (nextNode2[1], nextNode2[2], nextNode2[4], nextNode2[4] + currentNode[2])
			nodeTransferArray[x-1] = prevNode2
			nodeTransferArray[x+1] = nextNode2
		end
	end

	for x=1:medium.numNodes
		packet::(Int, Int) = medium.line[x]
		currentNode::(Int, Int, Int, Int) = nodeTransferArray[x]
		medium.line[x] = (currentNode[3], currentNode[4])
	end

	# Collision detection
	for x=1:medium.numNodes
		packet::(Int, Int) = medium.line[x]
		if packet[1] > 0 && packet[2] > 0 && medium.nodes[x].check > 0 # Collision has occured 
			medium.nodes[x].i = medium.nodes[x].i + 1
			medium.nodes[x].backoffCounter = medium.nodes[x].i * 5
			medium.nodes[x].check = 0
			medium.line[x] = (0,0)
			# println("Collision!")
			# println(medium.line)
		end
	end

	# println(medium.line)
end