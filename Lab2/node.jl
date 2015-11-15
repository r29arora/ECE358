using DataStructures

type Node
	bufferSize::Int
isTransmitting::Bool
	lambda::Int
	buffer::Deque
	t_generate
	t_transmit

	function Node(bufferSize::Int)
		lambda = 10
		new(bufferSize, false, lambda, Deque{Any}(), 0, 0)
	end
end

# random number generation based on a poisson distribution
function rtime(node::Node)
	return ((-1 / node.lambda) * log(1 - rand()))
end

# Generation packets to add to the buffer of the node
function generate(node::Node, t)
	if t >= node.t_generate 
		if node.bufferSize == -1
			push!(node.buffer, node.t_generate)
			node.t_generate = t + rtime(node)
			# println("generated ", node.t_generate)
		else
			if length(node.buffer) < node.bufferSize
				push!(node.buffer, node.t_generate)
				node.t_generate = t + rtime(node)
			end
		end
	end
end

# Transmit a single packet at a time 
function transmit(node::Node, t)
	if isempty(node.buffer) 
		return
	end

	if !node.isTransmitting
		node.isTransmitting = true
		node.t_transmit = t + 0.0001 # TODO: Calculate transmission time
	end

	if t >= node.t_transmit
		node.isTransmitting = false
		current_t_gen = shift!(node.buffer)
	end
end