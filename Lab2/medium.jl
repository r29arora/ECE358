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
	
function sense(medium::Medium, t)
	for x = 1:medium.numNodes
		result = transmit(medium.nodes[x], t)
		if result != -1
			packet = medium.line[x]
			medium.line[x] = (packet[1] + 1, packet[2] + 1)
			if packet[1] > 0 || packet[2]  > 0 
				medium.nodes[x].t_transmit = medium.nodes[x].t_transmit + rtime(medium.nodes[x])
			else
				medium.line[x] = (packet[1] + 1, packet[2] + 1)
			end
		end
	end
end	

function propogate(medium::Medium)
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
end