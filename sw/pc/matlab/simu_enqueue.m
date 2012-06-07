function [ event_queue, time ] = simu_enqueue( time, v, event_queue )
%SIMU_ENQUEUE Summary of this function goes here
%   Detailed explanation goes here

while isKey(event_queue, time)
    time = time + 0.000001;
end
event_queue(time) = v;

end

