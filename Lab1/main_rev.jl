using DataStructures

q = Queue(Any)
dep_q = Queue(Any)

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand())) 
end

avg_process_time = parseint(ARGS[4])
t = 0
transmission_rate = 10
packet_size = 50

t_arrival = calc_time(avg_process_time)
t_departure = calc_time(avg_process_time)


function arrival()
    global t
    global q
    global t_arrival
    global t_departure
    global avg_process_time
    global packet_size
    global transmission_rate
            
    if t >= t_arrival 
        enqueue!(q, 1)
        t_arrival = t + calc_time(avg_process_time)
        enqueue!(dep_q, t + (packet_size / transmission_rate))
        println("new packet generated", length(q), "in queue")
    end    
    
end

function departure()
    global t
    global t_departure
    global q
    
    if !isempty(dep_q) && !isempty(q)
        earliest_dep = dequeue!(dep_q)
        if t >= earliest_dep
            dequeue!(q)
            println("Packet Received ", length(q), "remaining")
        else
            enqueue!(dep_q, earliest_dep)
        end
    end
    
end

num_ticks = parseint(ARGS[5])
initial_t = calc_time(avg_process_time)

for x = 0:num_ticks
    t = initial_t * x
    arrival()
    departure()
end