function [ event_queue ] = init_simulator_4cyc( event_file, timebase, timeadj )
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
    t1 = ceil(t * 15)/15;
    simu_enqueue(t1, e, event_queue);
    t = t + f(i,3) + timeadj;
end

end

