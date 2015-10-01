using DataStructures

queue_size = parseint(ARGS[6])

q = Queue(Any)
dep_q = Queue(Any)

received_packets = 0
total_packets = 0

idle_time = 0
total_packet_length = 0

total_q = 0

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand())) 
end

avg_process_time = parseint(ARGS[4])
t = 0
transmission_rate = 100
packet_size = 50

t_arrival = calc_time(avg_process_time)
t_departure = calc_time(avg_process_time)
initial_t = calc_time(avg_process_time)

function arrival()
    global t
    global q
    global t_arrival
    global t_departure
    global avg_process_time
    global packet_size
    global transmission_rate
    global total_packets
    global total_packet_length
            
    if t >= t_arrival 
        if queue_size != -1 && length(q) >= queue_size 
            # do nothing, queue is full
        else 
            enqueue!(q, 1)
            t_arrival = t + calc_time(avg_process_time)
            enqueue!(dep_q, t + (packet_size / transmission_rate)) 
            total_packet_length = total_packet_length + length(q) 
        end

#        println("new packet generated", length(q), "in queue")
        total_packets = total_packets + 1
    end    
end

function departure()
    global t
    global t_departure
    global q
    global received_packets
    global idle_time
    global initial_t
    
    if !isempty(dep_q) && !isempty(q)
        earliest_dep = dequeue!(dep_q)
        if t >= earliest_dep
            dequeue!(q)
#            println("Packet Received ", length(q), "remaining")
            received_packets = received_packets + 1
        else
            enqueue!(dep_q, earliest_dep)
            idle_time = idle_time + initial_t
        end
    end
    
end

num_ticks = parseint(ARGS[5])

for x = 0:num_ticks
    t = initial_t * x
    total_q = total_q + length(q)
    arrival()
    departure()
end

println("Total Packets Generated = ", total_packets)
println("Total Packets Processed = ", received_packets)
println("Average Number of Packets in the Buffer / Queue = ", total_q / num_ticks)
println("Sojurn Time = ", total_packet_length * (packet_size / transmission_rate) / total_packets)
println("Idle Time = ", idle_time)