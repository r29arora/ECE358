using DataStructures

function calc_arrival_time()
	return (( -1 / AverageProcessingTime )*log(1 - rand(0:1)) * 1000000)
end

function arrival(t_arrival, t_departure, queue, packet_size, transmission_rate)
	if t >= t_arrival
		new_packet = 1
		enqueue!(queue, new_packet)
		t_arrival= t + calc_arrival_time()
		t_departure= t + (packet_size/transmission_rate)
		# Also need to consider packet loss case when queue is full '''
	end
end

function departure(t_departure, queue)
	if t >= t_departure
		x = dequeue!(queue)
	end
end

# ''' t is incrementing up at a constant rate, t_departure is incrementing up at constant rate '''

# running the code on the problem instance passed in via command line args.
if isempty(ARGS)
	println("M D 1 K AverageProcessingTime")
else
	inputIsDeterministic = ARGS[1]
	outputIsDeterministic = ARGS[2]
	numOfServers = ARGS[3]
	queueSize = parseint(ARGS[4])
	AverageProcessingTime = parseint(ARGS[5])
	num_of_ticks = parseint(ARGS[6])
	t = parseint(ARGS[7])

	packet_size = 10
	transmission_rate = 2

	queue = Queue(Any)

	t_arrival = calc_arrival_time()
	t_departure = 10

	for i = 0:num_of_ticks
		t = i * t
		arrival(t_arrival, t_departure, queue, packet_size, transmission_rate)
		departure(t_departure, queue)
	end


	println("inputIsDeterministic: ", inputIsDeterministic)
	println("outputIsDeterministic: ", outputIsDeterministic)
	println("numOfServers: ", numOfServers)
	# create_report()
	# println(gtsp_solver(queueSize, true))
end