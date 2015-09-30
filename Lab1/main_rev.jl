using DataStructures

global q = Queue(Any)

function calc_time(lambda)
    # Generates a random time for the next packet
    num =  ((-1 / lambda) * log(1 - rand(0:1)))
    return num
end

avg_process_time = parseint(ARGS[4])
t = 0
transmission_rate = 2
packet_size = 10

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
        t_departure = t + (packet_size / transmission_rate)
    end
end

function departure()
    global t
    global t_departure
    global q
    
    if t >= t_departure
        dequeue!(q)
    end
end

num_ticks = parseint(ARGS[5])
initial_t = parseint(ARGS[3])

for x = 0:num_ticks
    t = initial_t * x
    println(t)
    arrival()
    departure()
end