using DataStructures

q = Queue(Any)

function calc_time(lambda)
    # Generates a random time for the next packet
    return ((-1 / lambda) * log(1 - rand())) 
end

avg_process_time = parseint(ARGS[4])
t = 0
transmission_rate = 1
packet_size = 100000

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
        println("q = ", q)
    end    
    
    if t >= t_departure && !isempty(q)
#        println("Packet Received ", length(q))
        dequeue!(q)
    end
    
    if t >= t_arrival
        t_departure = t + (packet_size / transmission_rate)
    end
end
#
#function departure()
#    global t
#    global t_departure
#    global q
#    
#end

num_ticks = parseint(ARGS[5])
initial_t = calc_time(avg_process_time)

for x = 0:num_ticks
    t = initial_t * x
    arrival()
#    departure()
end