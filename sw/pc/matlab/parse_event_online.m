function [ events, t, status ] = parse_event_online( pkt_recv, sensors, t )
%PARSE_EVENT_ONLINE Parse log file and output received events online.
%   

if (isempty(t))
    t = zeros(max(sensors), 10);
end
events = zeros(0, 4);

d = pkt_recv;
%%% decode multi-state events
d(6) = d(6) + 2 * (d(2)>32);
d(2) = bitand(d(2), 31);
%%% %%%
if ~any(d(2)==sensors) 
    %display('discarding wrong data');
    status = -1; % wrong sensor id
    return
end
trans = 4 - d(3);
slot = trans * 8 - d(4);
lostevent = 0;
if (d(3)==0 && d(4)==0)
    trans = 0;
    slot = 0;
end
seqdiff = d(5) - t(d(2),4);
if (seqdiff < 0); seqdiff = seqdiff + 16; end
if (t(d(2),1) == 0); seqdiff = 1; end

% 7 - recv packets, 8 - total packets
t(d(2),7) = t(d(2),7)+1;
t(d(2),8) = t(d(2),8)+seqdiff;

newevent = 0;
% time constraint
if t(d(2),1) == 0 || d(1)-t(d(2),1) > 2.4
    newevent = 1;
% event type
elseif t(d(2),2) ~= d(6)
    newevent = 1;
% new transmission
elseif trans == 0 && d(6)>=2 
    newevent = 1;
% transmission number
elseif trans - t(d(2),3) ~= seqdiff
    newevent = 1;
    lostevent = 1;
    %disp('lost event case 2');
end

if seqdiff > 5
    lostevent = 1;
    %disp('lost event case 1');
end

if lostevent; t(d(2),10) = t(d(2),10)+1; end

if newevent
    % time, id, event, lostevent_before
    events = [d(1)-slot/15, d(2), d(6), lostevent];
    t(d(2), 5:6) = [d(1) slot];
    status = 1; % new event

    % 9 - recv events, 10 - total events
    t(d(2),9) = t(d(2),9)+1;
    t(d(2),10) = t(d(2),10)+1;
else
    status = 0; % repeated data
end

% save state: time, event, trans, seq
t(d(2),1:4) = [d(1) d(6) trans d(5)];

end

