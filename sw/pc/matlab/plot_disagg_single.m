function [ e, plot1 ] = plot_disagg_single ( disagg_result, timespan,  ax )

w = 0;
e = 0;
d = zeros(0,2);
if disagg_result.events(1,3) == 1
    d = [timespan(1) 0];
    e1 = 0;
elseif disagg_result.events(1,3) == 0
    d = [timespan(1) -disagg_result.events(1,2)];
    e1 = -disagg_result.events(1,2);
    t1 = timespan(1);
end

for i=1:size(disagg_result.events, 1)
    if disagg_result.events(i,3) == 1
        d = [d; disagg_result.events(i,1) w];
        w = w + disagg_result.events(i,2);
        d = [d; disagg_result.events(i,1) w];
        e1 = w;
        t1 = disagg_result.events(i,1);
    elseif disagg_result.events(i,3) == 0
        w = -disagg_result.events(i,2);
        d = [d; disagg_result.events(i,1) w];
        e2 = w;
        t2 = disagg_result.events(i,1);
        w = 0;
        d = [d; disagg_result.events(i,1) w];
        e = e + (e1+e2)*(t2-t1)/2;
    end
end

d = [d; timespan(2) w];
e = e + w * (timespan(2)-t1);
plot1 = plot(ax, d(:,1)-timespan(1), d(:,2));

end
