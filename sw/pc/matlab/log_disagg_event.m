function [ disagg_events ] = log_disagg_event( id, timestamp, dpower, status, disagg_events )
%LOG_DISAGG_EVENT Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(disagg_events)
    if id == disagg_events{i}.id
        disagg_events{i}.events(end+1,:) = [timestamp, dpower, status];
        if status<2
            disagg_events{i}.abswatts(end+1) = abs(dpower);
        end
        return;
    end
end

disagg_events{end+1}.id = id;
disagg_events{end}.events = [timestamp, dpower, status];
disagg_events{end}.abswatts = [];
if status<2
    disagg_events{end}.abswatts(end+1) = abs(dpower);
end

end

