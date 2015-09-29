
function consumer(queueSize, ticTocTime)
	"""
	Consumes on tic() and toc() 
	"""
	totalTime = randomGenerator(ticTocTime)

	println("This is how much time it took to generate all the packets: ", totalTime)
end



function calc_arrival_time()
	u=rand(0,1) //generate random number between 0...1
	arrival_time= ((-1/lambda)*log(1-u) * 1000000)
	return arrival_time
end

function arrival()
	if(t>=packet_arrival_time){
		packet_queue.add(new_packet)
		t_arrival=t + calc_arrival_time()
		t_departure= t+ (packet_size/transmission_rate)
		//Also need to consider packet loss case when queue is full
	}
end

function departure()
	if(t>=t_departure){
		queue.pop()
	}
end

main(args[]){
		intialize_variables(args)
		t_arrival = calc_arrival_time //calculate first packet arrival time
		for(i=0;i<=num_of_ticks;i++){
			arrival()
			departure()
		}
		create_report();
}

# running the code on the problem instance passed in via command line args.
if isempty(ARGS)
	println("M D 1 K ticTocTime")
else
	inputIsDeterministic = ARGS[1]
	outputIsDeterministic = ARGS[2]
	numOfServers = ARGS[3]
	queueSize = ARGS[4]

	ticTocTime = parseint(ARGS[5])


	println("inputIsDeterministic: ", inputIsDeterministic)
	println("outputIsDeterministic: ", outputIsDeterministic)
	println("numOfServers: ", numOfServers)
	println(consumer(queueSize, ticTocTime))
	# println(gtsp_solver(queueSize, true))
end