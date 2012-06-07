function [ d_events, id_map ] = demux_recv_events( recvevents )
%DEMUX_RECV_EVENTS Summary of this function goes here
%   Detailed explanation goes here

d_events = struct([]);
id_map = zeros(0,2);
for i=1:length(recvevents)
    t = recvevents(i);
    if any(id_map(:,1)==t.id)
        m = find(id_map(:,1)==t.id, 1, 'first');
        m = id_map(m,2);
    else
        m = length(d_events)+1;
        id_map(end+1,:) = [t.id, m];
        d_events(m).id = t.id;
        d_events(m).events = zeros(0,4);
    end
    % timestamp, event(0/1), lost_before, id in original series 
    d_events(m).events(end+1,:) = [t.timestamp, t.event, t.lost_before, i];
end

[~, i] = sort(id_map(:,1));
id_map = id_map(i,:);

end

