using DataStructures

type Node
	bufferSize::Int
	isServicing::Bool
	lambda::Int

	function Node()
		new(-1, false, 10)
	end
end

function generate(node::Node)
end

function transmitn(node::Node)
end

function rtime(node::Node)
	return ((-1 / node.lambda) * log(1 - rand()))
end