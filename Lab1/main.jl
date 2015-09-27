
function consumer(queueSize, ticTocTime)
	"""
	Consumes on tic() and toc() 
	"""
	totalTime = randomGenerator(ticTocTime)

	println("This is how much time it took: ", totalTime)
end

function randomGenerator(ticTocTime)
	"""
	generates on random time frame if it can. 
	"""
	totalTime = 0

	currentPacketProcessingTime = 0

	# How do we make this truely random?
	# What if we produce a shit ton of random variables?
	for packetsProcessed = 1:100
		println("it's running", packetsProcessed)
		while currentPacketProcessingTime <= ticTocTime 
			currentPacketProcessingTime = currentPacketProcessingTime + rand()
			totalTime = totalTime + ticTocTime;
		end
		currentPacketProcessingTime = currentPacketProcessingTime - ticTocTime
	end

	return totalTime

end

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