using CSMAStructures

type CSMA
	N::Int # number of nodes
	A::Int # arrival rate in packets / second
	P::Int # persistence paramter (-1 for non-persistent)
	t      # defintion of time for simulation

	function CSMA(N::Int, A::Int, P::Int)
		new(N,A,P, 0)
	end
end

function run(csma::CSMA) 
	lambda = csma.A * seconds_per_tick # arrival rate in (packets/tick)
	node = Node(lambda)
	medium = Medium(csma.N, lambda)

	medium.line[1] = (1,1,4)

	for x = 0:num_ticks
		# println(medium.line)
		csma.t = csma.t + seconds_per_tick
		# sense(medium, csma.t)
		propogate(medium)
	end
			
	println("total received = ", medium.total_received)		
	println("transmission rate (mpbs) = ", averageThroughput(medium))
end