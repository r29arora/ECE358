using DataStructures

# Tick definition (1000 ticks = 1 second)
const speed_of_light = 3*(10^8)
const prop_delay = 10 / ((2/3)*speed_of_light)
const ticks_per_sec = 1 / prop_delay

# Constant values
const transmission_speed = 1 * ticks_per_sec # 1 Mbps in megabits/tick
const packet_length = 1500 * 8 / 10^9 # 1500 bytes in Megabits 

type Node
	bufferSize::Int
	isTransmitting::Bool
	check::Int
	lambda::Int
	backoffCounter::Int
	i::Int
	buffer::Deque
	t_generate
	t_transmit

	function Node(bufferSize::Int, lambda::Int)
		new(bufferSize, 
			false, 
			0,
			lambda,
			0,
			0,
			Deque{Any}(),
			((-1 / lambda) * log(1 - rand())), 
			0)
	end
end

# random number generation based on a poisson distribution
function rtime(node::Node)
	return ((-node.lambda) * log(1 - rand()))
end

# Generation packets to add to the buffer of the node
function generate(node::Node, t)
	if t >= node.t_generate 
		if node.bufferSize == -1
			push!(node.buffer, node.t_generate)
			t_gen = node.t_generate
			node.t_generate = t + rtime(node)
			return t_gen
		else
			if length(node.buffer) < node.bufferSize
				push!(node.buffer, node.t_generate)
				t_gen = node.t_generate
				node.t_generate = t + rtime(node)
				return t_gen
			end
		end
	end

	return -1
end

# Transmit a single packet at a time 
function transmit(node::Node, t)
	if isempty(node.buffer) 
		return -1
	end

	if !node.isTransmitting && node.check == 0 && node.backoffCounter == 0
		node.isTransmitting = true
		node.t_transmit = t + (packet_length / transmission_speed) # TODO: Calculate transmission time (Length / Rate)
	end

	if t >= node.t_transmit
		node.isTransmitting = false
		current_t_gen = shift!(node.buffer)
		return current_t_gen
	end

	return -1
end