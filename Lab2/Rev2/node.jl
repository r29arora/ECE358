using DataStructures, CSMAStructures

# random number generation based on a poisson distribution
function rtime(lambda)
	return (((-lambda) * log(1 - rand())) / seconds_per_tick)
end

type Node
	buffer::Deque # buffer for generated packets
	lambda::Float64  # rate of arrival of packets (packets / tick)
	t_generate::Float64 # tick for next generated packet
	t_transmit::Float64 # tick for next transmitted packet (rate of 1 Mbps)
	isTransmitting::Bool # true if a packet is being transmitted to the medium
	total_generated::Int # total number of packets generated
	total_transmitted::Int # total number of packets transmitted to the medium
	outputBuffer::Deque # packets waiting to be transmitted through the medium
	t_wait::Float64  # time before transmission through the medium is allowed
	i::Int # counter for exponential backoff

	function Node(lambda)
		new(Deque{Any}(), lambda, rtime(lambda), 0, false, 0, 0, Deque{Any}(), 0, 1)
	end
end

# generation of packets into an infinite queue at a rate of lambda packets / tick
function generate(node::Node, t)
	if t >= node.t_generate
		push!(node.buffer, node.t_generate)
		node.t_generate = t + rtime(node.lambda)
		node.total_generated = node.total_generated + 1
		# println("Generated at t = ", node.t_generate)
	end
end

# transmission of packets to the medium
function transmit(node::Node, t)
	if isempty(node.buffer)
		return
	end

	if !node.isTransmitting
		node.isTransmitting = true
		node.t_transmit = t + trans_delay
	end

	if t >= node.t_transmit
		node.isTransmitting = false
		shift!(node.buffer)
		push!(node.outputBuffer, node.t_transmit)
		node.total_transmitted = node.total_transmitted + 1
		# println("outputBuffer = ", node.outputBuffer)
	end	
end
