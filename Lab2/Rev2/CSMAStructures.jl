
# constants
distance = 10 # distance between adjacent nodes (m)
speed_of_transmission = 299792458 # speed of light through copper (m/s)
prop_delay = distance / speed_of_transmission # delay to transmit to an adjacent node
seconds_per_tick = 1 / speed_of_transmission # time in seconds for a single tick
packet_length = 1500 # packet length in bits
transmission_rate = (10^6) # transmission rate in bits per second
num_ticks = 1

# by the current defintion of a single tick, adjacent nodes are 10 ticks apart

module CSMAStructures
	export CSMA
	export Medium
	export Node
	require("CSMA.jl")
	require("medium.jl")
	require("node.jl")
end