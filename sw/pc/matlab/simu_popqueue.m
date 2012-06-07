function [ k, v, event_queue ] = simu_popqueue( event_queue )
%SIMU_POPQUEUE Summary of this function goes here
%   Detailed explanation goes here

ks = keys(event_queue);
k = ks{1};
v = event_queue(k);
remove(event_queue, k);

end

