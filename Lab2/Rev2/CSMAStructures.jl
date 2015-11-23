
# constants
const distance = 10 # distance between adjacent nodes (m)
const speed_of_transmission = 299792458 # speed of light through copper (m/s)
const prop_delay = 0 # delay in ticks
const seconds_per_tick = 0.001 # time in seconds for a single tick
const packet_length = 1500 * 8 # packet length in bits
const transmission_rate = (10^6) # transmission rate in bits per second

const trans_delay_s = packet_length / transmission_rate # transmission delay in seconds
const trans_delay = trans_delay_s / seconds_per_tick

const num_ticks = 500
const Tp = 5
# by the current defintion of a single tick, adjacent nodes are 10 ticks apart

module CSMAStructures
	export CSMA
	export Medium
	export Node
	require("CSMA.jl")
	require("medium.jl")
	require("node.jl")
end