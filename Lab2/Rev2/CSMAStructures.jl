
# constants
distance = 10 # distance between adjacent nodes (m)
speed_of_transmission = 299792458 # speed of light through copper (m/s)
prop_delay = 0 # delay in ticks
seconds_per_tick = 0.0001 # time in seconds for a single tick
packet_length = 1500 # packet length in bits
transmission_rate = (10^6) # transmission rate in bits per second

trans_delay_s = packet_length / transmission_rate # transmission delay in seconds
trans_delay = trans_delay_s / seconds_per_tick

num_ticks = 1000

# by the current defintion of a single tick, adjacent nodes are 10 ticks apart

module CSMAStructures
	export CSMA
	export Medium
	export Node
	require("CSMA.jl")
	require("medium.jl")
	require("node.jl")
end