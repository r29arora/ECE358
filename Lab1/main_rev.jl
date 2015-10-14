using DataStructures

queue_size = parse(Int, ARGS[3])
num_ticks = parse(Int, ARGS[2])
avg_process_time = parse(Int, ARGS[1])

q = Deque{Any}()

t = 0
received_packets = 0
generated_packets = 0
total_packets = 0
packets_lost = 0
total_sojurn = 0
idle_time = 0
isBusy = false
total_q = 0

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand()))
end

transmission_rate = 1000000
packet_size = 2000

t_generate = calc_time(avg_process_time)
t_departure = t_generate + (packet_size / transmission_rate)

function generate()
    global t
    global q
    global t_generate
    global t_departure
    global avg_process_time
    global packet_size
    global transmission_rate
    global total_packets
    global total_packet_length
    global packets_lost
    global generated_packets

    if t >= t_generate
        rand_time = calc_time(avg_process_time)
        t_generate = t +                                        rand_time
        println("t_generate = ", t_generate)


        if queue_size == -1 
            push!(q, t_generate)
        else
            if length(q) < queue_size 
                push!(q, t_generate)
            else 
                packets_lost = packets_lost + 1
            end
        end
        
        total_packets = total_packets + 1
    end    
end

function consume()
    global t
    global t_departure
    global q
    global received_packets
    global idle_time
    global initial_t
    global isBusy
    global total_sojurn

    if length(q) == 0
        idle_time = idle_time + 0.001
    end

    if t >= t_departure && isBusy
        println("t_departure = ", t_departure)
        isBusy = false
        received_packets = received_packets + 1
        time_to_process = (t_departure - shift!(q))
        total_sojurn = total_sojurn + time_to_process
        return
    end

    if length(q) > 0 && !isBusy
        t_departure = t + (packet_size / transmission_rate)
        isBusy = true
    end
end

# Main Program

for y = 0:0
    for x = 0:num_ticks
        t = x * 0.0001
        total_q = total_q + length(q)
        generate()
        consume()
    end

    println("total_packets = ", total_packets)
    println("received_packets = ", received_packets)
    println("lost packets = ", packets_lost)
    println("E[N] = ", total_q / num_ticks)
    println("E[T] = ", total_sojurn / received_packets)
    println("P_IDLE = ", idle_time)
    println("utilization = ", avg_process_time * packet_size / transmission_rate)

end
