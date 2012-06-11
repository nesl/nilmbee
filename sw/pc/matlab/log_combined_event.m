function [ combined_events, new_id, parsed_events, revt_pnt_new, dpower, w ] = log_combined_event( recvevents, wattsevents, revt_pnt, combined_events )
%LOG_COMBINED_EVENT Summary of this function goes here
%   Detailed explanation goes here

tmp = zeros(64,2);
tmp(:,2) = -1;
parsed_events_ids = zeros(0,1);
t1 = 0;

for i=revt_pnt:length(recvevents)
    if t1 && recvevents(i).timestamp - t1 > 15
        i = i-1;
        break;
    end
    if ~(tmp(recvevents(i).id, 1))
        tmp(recvevents(i).id, 1) = i;
        if tmp(recvevents(i).id, 2)<0; tmp(recvevents(i).id, 2) = recvevents(i).event; end
        parsed_events_ids(end+1) = i;
        t1 = recvevents(parsed_events_ids(1)).timestamp;
    else
        if recvevents(i).event == tmp(recvevents(i).id, 2)
            parsed_events_ids = parsed_events_ids(parsed_events_ids ~= tmp(recvevents(i).id));
            parsed_events_ids(end+1) = i;
            tmp(recvevents(i).id) = i;
            t1 = recvevents(parsed_events_ids(1)).timestamp;
        else
            parsed_events_ids = parsed_events_ids(parsed_events_ids ~= tmp(recvevents(i).id));
            tmp(recvevents(i).id) = 0;
            if isempty(parsed_events_ids)
                t1 = recvevents(i).timestamp;
            else
                t1 = recvevents(parsed_events_ids(1)).timestamp;
            end
        end
    end
end
revt_pnt_new = i + 1;
parsed_events = recvevents(parsed_events_ids);

w = zeros(0,1);
for i = revt_pnt:revt_pnt_new-1  %parsed_events_ids
    w = [w; recvevents(i).watts_events(:,1)];
end
w = unique(w);
dpower = 0;
for i = w'
    dpower = dpower + wattsevents(i).delta_watts;
end

%if length(parsed_events_ids)<2
if isempty(parsed_events_ids) || (length(parsed_events_ids)==1 && abs(dpower)>0.005 && (dpower * (parsed_events(1).event-0.5) > 0) && (abs(dpower)<0.4 || parsed_events(1).id==7))
    new_id = 0;
else
    combined_events{end+1}.delta_watts = dpower;
    combined_events{end}.recvevents = parsed_events;
    combined_events{end}.recvevents_ids = parsed_events_ids;
    new_id = length(combined_events);
end


end

