function [ t ] = get_on_time_from_power( log_watts, th )
%GET_ON_TIME_FROM_POWER Summary of this function goes here
%   Detailed explanation goes here

t = 0;
if isempty(log_watts); return; end

s = log_watts(:,2)>th;
ds = [s(1);diff(s);-s(end)];
ds_on = (ds==1);
ds_off = (ds==-1);

p = 1;
while(1)
    e1 = find(ds_on(p:end), 1, 'first') + p - 1;
    e2 = find(ds_off(p:end), 1, 'first') + p - 1;
    if isempty(e1); break; end
    if e2 > size(log_watts,1)
        t = t + log_watts(e2-1,1) - log_watts(e1,1);
        break;
    else
        t = t + log_watts(e2,1) - log_watts(e1,1);
        p = e2 + 1;
    end
end

end

