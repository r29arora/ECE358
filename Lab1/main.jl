
function consumer(queueSize, ticTocTime, currentCombinedTime)
	"""
	Consumes on tic() and toc() 
	"""
	totalTime = 0

	while oneHundredPackets < 100
		totalTime = totalTime + randomGenerator(ticTocTime, currentCombinedTime, oneHundredPackets)
	end

	println("This is how much time it took: ", totalTime)
end

function randomGenerator(ticTocTime, currentCombinedTime, oneHundredPackets)
	"""
	generates on random time frame if it can. 
	"""

	# How do we make this truely random?
	# What if we produce a shit ton of random variables?

	while currentCombinedTime <= ticTocTime 
		tmp = rand()
		currentCombinedTime = currentCombinedTime + tmp
		oneHundredPackets = oneHundredPackets + 1
		if oneHundredPackets == 100
			return currentCombinedTime
		end
	end

	currentCombinedTime = currentCombinedTime - ticTocTime

	return currentCombinedTime

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

	currentCombinedTime = -1
	oneHundredPackets = 0


	println("inputIsDeterministic: ", inputIsDeterministic)
	println("outputIsDeterministic: ", outputIsDeterministic)
	println("numOfServers: ", numOfServers)
	println(consumer(queueSize, ticTocTime, currentCombinedTime))
	# println(gtsp_solver(queueSize, true))
end