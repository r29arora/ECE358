using DataStructures, CSMAStructures

# random number generation based on a poisson distribution
function rtime(lambda)
	return ((-lambda) * log(1 - rand()))
end

type Node
	buffer::Deque # buffer for generated packets
	lambda # rate of arrival of packets (packets / tick)
	t_generate # tick for next generated packet
	t_transmit # tick for next transmitted packet (rate of 1 Mbps)
	isTransmitting # true if a packet is being transmitted to the medium
	total_generated # total number of packets generated
	total_transmitted # total number of packets transmitted to the medium
	outputBuffer::Deque # packets waiting to be transmitted through the medium
	t_wait # time before transmission through the medium is allowed

	function Node(lambda)
		new(Deque{Any}(), lambda, rtime(lambda), 0, false, 0, 0, Deque{Any}(), 0)
	end
end

# generation of packets into an infinite queue at a rate of lambda packets / tick
function generate(node::Node, t)
	# println(t, " >= ", node.t_generate)
	if t >= node.t_generate
		push!(node.buffer, node.t_generate)
		node.t_generate = t + rtime(node.lambda)
		node.total_generated = node.total_generated + 1
	end
end

# transmission of packets to the medium
function transmit(node::Node, t)
	if isempty(node.buffer)
		return
	end

	if !node.isTransmitting
		node.isTransmitting = true
		next_transmit = (packet_length / transmission_rate)
		node.t_transmit = t + next_transmit
	end

	# println(t, " >= ", node.t_transmit)
	if t >= node.t_transmit
		node.isTransmitting = false
		shift!(node.buffer)
		node.total_transmitted = node.total_transmitted + 1
		push!(node.outputBuffer, node.t_transmit)
		# println(node.outputBuffer)
	end	
end
