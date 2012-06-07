function [ r ] = train_single_event( wattsevents, recvevents )
%TRAIN_SINGLE_EVENT Summary of this function goes here
%   Detailed explanation goes here

s = cell(100,2);
r = zeros(100,2);

for i=1:length(wattsevents)
    tmp = wattsevents(i);
    if tmp.delta_watts && length(tmp.recv_event)==1 
        seid = tmp.recv_event(1);
        if (recvevents(seid).event-0.5)*tmp.delta_watts > 0
            s{recvevents(seid).id, recvevents(seid).event+1}(end+1) = tmp.delta_watts;
        end
    end
end

% 1st pass: single clear events
for i=1:size(s,1)
    if ~isempty(s{i,1})
        r(i,1) = mean(s{i,1});
    end
    if ~isempty(s{i,2})
        r(i,2) = mean(s{i,2});
    end
end 

end

