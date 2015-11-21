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
	println("Lambda = ", lambda, " packets per tick")
	medium = Medium(csma.N, lambda)

	for x = 1:num_ticks
		csma.t = csma.t + 1
		prop(medium)
		sense(medium, csma.t)
		# println(medium.line)
	end
			
	println("total received = ", medium.total_received)		
	println("transmission rate (mpbs) = ", averageThroughput(medium))
end