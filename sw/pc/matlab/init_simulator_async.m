function [ event_queue ] = init_simulator_async( event_file, timebase, timeadj, retrans_count, pkt_delivery_rate )
%INIT_SIMULATOR Summary of this function goes here
%   Detailed explanation goes here

f = load(event_file);
t = timebase;
event_queue = containers.Map('KeyType', 'double', 'ValueType', 'any');
e = struct();
e.type = 0;
e.cycle = 0;
simu_enqueue(0, e, event_queue);
for i=1:size(f,1)
    e = struct();
    e.type = 1;
    e.id = f(i,1);
    e.event = f(i,2);
    e.retrans_count = retrans_count;
    e.pkt_delivery_rate = pkt_delivery_rate;
    simu_enqueue(t, e, event_queue);
    t = t + f(i,3) + timeadj;
end

end

