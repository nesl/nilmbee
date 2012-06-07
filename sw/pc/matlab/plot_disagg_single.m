function plot_disagg_single ( disagg_result, timespan,  ax )

w = 0;
d = zeros(0,2);
if disagg_result.events(1,3) == 1
    d = [timespan(1) 0];
elseif disagg_result.events(1,3) == 0
    d = [timespan(1) -disagg_result.events(1,2)];
end

for i=1:size(disagg_result.events, 1)
    if disagg_result.events(i,3) == 1
        d = [d; disagg_result.events(i,1) w];
        w = w + disagg_result.events(i,2);
        d = [d; disagg_result.events(i,1) w];
    elseif disagg_result.events(i,3) == 0
        w = -disagg_result.events(i,2);
        d = [d; disagg_result.events(i,1) w];
        w = 0;
        d = [d; disagg_result.events(i,1) w];
    end
end

d = [d; timespan(2) w];
plot(ax, d(:,1), d(:,2));

end
