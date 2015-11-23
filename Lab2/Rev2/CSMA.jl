using CSMAStructures

type CSMA
	N::Int # number of nodes
	A::Float64 # arrival rate in packets / second
	P::Int # persistence paramter (-1 for non-persistent), value from 0 - 100 for probability
	t      # defintion of time for simulation

	function CSMA(N::Int, A::Float64, P::Int)
		new(N,A,P, 0)
	end
end

function run(csma::CSMA) 
	lambda = csma.A # arrival rate in (packets/tick)
	println("Lambda = ", lambda, " packets per second")
	medium = Medium(csma.N, lambda)
	initBuffer(medium)

	for x=1:num_ticks
		csma.t = csma.t + 1
		propogate(medium, csma.t)
		sense(medium, csma.t)
	end
	
	total_gen = 0

	for x=1:medium.numNodes
		total_gen = total_gen + medium.nodes[x].total_generated
	end

	avg_packets::Float64 = total_gen/medium.numNodes
	avg_received::Float64 = medium.total_received / medium.numNodes

	# println("average generated = ", avg_packets)
	# println("average received = ", avg_received)

	println("total_gen = ", total_gen)
	println("Simulated lambda = ", avg_packets / (num_ticks * seconds_per_tick))

	println("transmission rate (mpbs) = ", averageThroughput(medium))
	println("collisions = ", medium.num_collisions)
	println("packets dropped = ", medium.packets_dropped)
end