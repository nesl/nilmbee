function [ states ] = get_state_by_recv( recvevents, timespan )
%GET_STATE_BY_RECV Summary of this function goes here
%   Detailed explanation goes here

states = zeros(0,3);
t = recvevents.events;
init = 0;

for j=1:size(t,1)
    if t(j,2) > 1
        % bypass multistate events
        continue;
    end
    if ~init
        flag = 1-t(j,2);
        time = timespan(1);
        init = 1;
    end
    if t(j,3) || t(j,2) == flag
        display('lost event!');
        states = [states; time, t(j,1), -1];
    else
        states = [states; time, t(j,1), flag];
    end
    flag = t(j,2);
    time = t(j,1);
end

states = [states; time, timespan(2), flag];

end

