using DataStructures, NodeStructures

# medium.line represents an array of packets of type (Int, Int, Int)
# this represents (# nodes Left, # nodes Right, how long it should detect a collision)


type Medium
	line::Array
	numNodes::Int
	function Medium(numNodes::Int)
		new(Array((Int, Int, Int), numNodes), numNodes)
	end
end


function propogate(medium::Medium)
	nodeTransferArray = Array((Int, Int, Int, Int), medium.numNodes)
	fill!(nodeTransferArray, (0, 0, 0, 0))

	for x = 1:medium.numNodes
		packet::(Int, Int, Int) = medium.line[x]
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
		packet::(Int, Int, Int) = medium.line[x]
		currentNode::(Int, Int, Int, Int) = nodeTransferArray[x]

		packetValue = packet[3]

		if packetValue > 0
			packetValue = packetValue - 1
		end

		medium.line[x] = (currentNode[3], currentNode[4], packetValue)
	end
end