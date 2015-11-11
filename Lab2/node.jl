using DataStructures

type Node
	bufferSize::Int
	isServicing::Bool
	lambda::Int
	buffer::Deque

	function Node(bufferSize::Int)
		new(-bufferSize, false, 10, Deque{Any}())
	end
end

function generate(node::Node)
end

function transmit(node::Node)
end

function rtime(node::Node)
	return ((-1 / node.lambda) * log(1 - rand()))
end