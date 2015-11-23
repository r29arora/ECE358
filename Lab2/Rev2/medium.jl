using CSMAStructures, DataStructures

type Medium 
	line::Array
	nodes::Array
	numNodes::Int
	total_received::Int
	num_collisions::Int
	packets_dropped::Int
	function Medium(numNodes::Int, lambda::Float64)
		nodesArray = Array(Any, 1, numNodes)
		lineArray = Array(Any, 1, numNodes)

		for x=1:numNodes
			nodesArray[x] = Node(lambda)
			lineArray[x] = Deque{(Int, Int, Int)}() # (Int, Int, Int) => (destinationIndex, sourceIndex, transmitTime)
		end

		new(lineArray, nodesArray, numNodes, 0, 0, 0)
	end
end

tempBuffer = Array(Deque)

function initBuffer(medium::Medium)
	global tempBuffer = Array(Any, 1, medium.numNodes)

	for x=1:medium.numNodes
		tempBuffer[x] = Deque{(Int, Int, Int)}()
	end
end

function clearBuffer(medium::Medium)
	global tempBuffer

	for x=1:medium.numNodes
		empty!(tempBuffer[x])
	end

	# println("tempBuffer = ", tempBuffer)

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

function sense(medium::Medium, t)
	for x=1:medium.numNodes
		generate(medium.nodes[x], t)
	end

	transmit(medium, t)

end

function transmit(medium::Medium, t)
	for x=1:medium.numNodes
		node::Node = medium.nodes[x]

		if isempty(node.buffer)
			return
		end

		if !node.isTransmitting
			node.isTransmitting = true
			node.t_transmit = t + trans_delay
			push!(medium.line[x], (destination(medium,x), x, t+trans_delay))
			println("node ", x, " line = ", medium.line, " t = ", t)
		end

		if t >= node.t_transmit
			node.isTransmitting = false
			shift!(node.buffer)
			node.total_transmitted= node.total_transmitted + 1
		end

		medium.nodes[x] = node
	end
end

function propogate(medium::Medium, t)
	global tempBuffer::Array

	for x=1:medium.numNodes
		currentBuffer::Deque = medium.line[x]
		if length(currentBuffer) > 0
			count = length(currentBuffer)
			y = 1
			while y <= count
				packet::(Int, Int, Int) = shift!(currentBuffer)

				if t >= packet[3]
					medium.total_received = medium.total_received + 1
					# println("received: ", medium.line, " t = ", t)
				else
					unshift!(currentBuffer, packet)
				end

				y = y + 1
			end
		end

		medium.line[x] = currentBuffer
	end

	clearBuffer(medium)
end


# returns the average throughput of the medium
function averageThroughput(medium::Medium)
	packets_per_tick = medium.total_received / num_ticks
	packets_per_second = packets_per_tick / seconds_per_tick 
	bits_per_second = packets_per_second * packet_length
	return bits_per_second / (10^6)
end