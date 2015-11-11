using DataStructures

num_ticks = parse(Int, ARGS[1])
lambda = parse(Int, ARGS[2])
buffer_size = parse(Int, ARGS[3])

transmission_rate = 1000000 
packet_size = 2000

buffer = Deque{Any}()

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand()))
end

t = 0
total_time = 0
t_generate = calc_time(lambda)
t_departure = 0
t_idle = 0
total_sojurn_time = 0

isServicing = false

total_buffer_length = 0

total_packets_generated = 0
total_packets_processed = 0
total_packets_lost = 0

function generate_packets()
	global t
	global t_generate
	global lambda
	
	global buffer
	global buffer_size

	global total_packets_generated
	global total_packets_lost

	if t >= t_generate

		if buffer_size == -1 
			push!(buffer, t_generate)
			total_packets_generated = total_packets_generated + 1
			t_generate = t + calc_time(lambda)
		else 
			if length(buffer) < buffer_size
				push!(buffer, t_generate)
				total_packets_generated = total_packets_generated + 1
				t_generate = t + calc_time(lambda)
			else
				total_packets_lost = total_packets_lost + 1
			end
		end
	end

end

function consume_packets()
	global t
	global buffer
	global t_idle

	global total_packets_processed
	global packet_size
	global transmission_rate
	global isServicing
	global t_departure
	global total_sojurn_time

	if !isempty(buffer)

		# println("isServicing = ", isServicing)

		if !isServicing 
			t_departure = t + (packet_size / transmission_rate)
			isServicing = true
		end

		if isServicing
			if t >= t_departure
				isServicing = false
				current_t_gen = shift!(buffer)
				sojurn_time = (t - current_t_gen)
				total_sojurn_time = total_sojurn_time + sojurn_time
				total_packets_processed = total_packets_processed + 1
			end
		end



	else
		t_idle = t_idle + 0.001
	end
end


for x = 0:num_ticks
	t = t + 0.001
	total_time = total_time + t
	total_buffer_length = total_buffer_length + length(buffer)
	generate_packets()
	consume_packets()
end

# println("total_packets_generated = ", total_packets_generated)
# println("total_packets_processed = ", total_packets_processed)
# println("total packets lost = ", total_packets_lost)
println("packet loss (%) = ", total_packets_lost / (total_packets_generated + total_packets_lost) * 100)
println("t_idle (%) = ", t_idle / t * 100)
println("E[N] = ", total_buffer_length / num_ticks)
println("E[T] = ", total_sojurn_time / total_packets_processed)
# println("total Ticks = ", t)
println("UT = ", lambda * packet_size / transmission_rate)
