function calc_arrival_time()
	return (( -1 / AverageProcessingTime )*log(1 - rand(0:1)) * 1000000)
end

function arrival(t)
	if t>=packet_arrival_time
		packet_queue.add(new_packet)
		t_arrival= t + calc_arrival_time()
		t_departure= t + (packet_size/transmission_rate)
		//Also need to consider packet loss case when queue is full
	end
end

function departure()
	if(t>=t_departure)
		queue.pop()
	end
end

main(args[]){
		
		
}

# running the code on the problem instance passed in via command line args.
if isempty(ARGS)
	println("M D 1 K AverageProcessingTime")
else
	inputIsDeterministic = ARGS[1]
	outputIsDeterministic = ARGS[2]
	numOfServers = ARGS[3]
	queueSize = ARGS[4]
	AverageProcessingTime = parseint(ARGS[5])

	t_arrival = calc_arrival_time(ticTocTime)

	for i = 0:100
		arrival()
		departure()
	end


	println("inputIsDeterministic: ", inputIsDeterministic)
	println("outputIsDeterministic: ", outputIsDeterministic)
	println("numOfServers: ", numOfServers)
	create_report()
	# println(gtsp_solver(queueSize, true))
end