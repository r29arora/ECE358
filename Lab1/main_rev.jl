using DataStructures

queue_size = parse(Int, ARGS[3])
num_ticks = parse(Int, ARGS[2])

q = Deque{Any}()

received_packets = 0
generated_packets = 0
total_packets = 0
packets_lost = 0

idle_time = 0
total_packet_length = 0
isBusy = false

total_q = 0

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand())) 
end

avg_process_time = parse(Int, ARGS[1])
t = 0
transmission_rate = 1000000
packet_size = 2000

t_generate = calc_time(avg_process_time)
t_departure = 0
initial_t = calc_time(avg_process_time)

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

        t_generate = t + calc_time(avg_process_time)

        if queue_size == -1 
            push!(q, t_generate)
        end
        
        total_packet_length = total_packet_length + length(q) 
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

    if length(q) > 0 && !isBusy
        t_departure = t + (packet_size / transmission_rate)
        isBusy = true
    end

    if length(q) == 0
        idle_time = idle_time + (1 / avg_process_time)
    end

    if t >= t_departure && isBusy
        isBusy = false
        shift!(q)
        received_packets = received_packets + 1
    end
    
end

for x = 0:avg_process_time * num_ticks
    t = x * (1 / avg_process_time)
    generate()
    consume()
    total_q = total_q + length(q)
end

println("Total Packets Generated = ", total_packets)
println("Total Packets Processed = ", received_packets)
println("Number of packets lost = ", packets_lost)
println("E[N], Average Number of Packets in the Buffer / Queue = ", total_q / (num_ticks * avg_process_time))
println("E[T], Sojurn Time = ", total_packet_length * (packet_size / transmission_rate) / total_packets)
println("P_IDLE, Idle Time = ", idle_time)