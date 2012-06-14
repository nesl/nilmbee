function [ f ] = plot_pwc_result_core( log_watts, wattsevents, recvevents, timespan )
%PLOT_PWC_RESULT_CORE Summary of this function goes here
%   Detailed explanation goes here

li1 = find(log_watts(:,1)>timespan(1), 1, 'first');
li2 = find(log_watts(:,1)>timespan(2), 1, 'first');

wi1 = find([wattsevents.timestamp]>timespan(1), 1, 'first');
wi2 = find([wattsevents.timestamp]>timespan(2), 1, 'first');

ri1 = find([recvevents.timestamp]>timespan(1), 1, 'first');
ri2 = find([recvevents.timestamp]>timespan(2), 1, 'first');

t1 = [timespan(1)];
y1 = [wattsevents(wi1).prev_watts];
for i=[wi1:wi2-1]
    t1 = [t1 wattsevents(i).timestamp wattsevents(i).timestamp];
    y1 = [y1 wattsevents(i).prev_watts wattsevents(i+1).prev_watts];
end
t1 = [t1 timespan(2)];
y1 = [y1 wattsevents(wi2).prev_watts];

t2 = [];
for i=[ri1:ri2-1]
    t2 = [t2 recvevents(i).timestamp];
end

f = figure('Position', [300,300,500,300], 'PaperPositionMode','auto');
ax1 = axes;
hold on;

m = median(log_watts(li1:li2,2));
m = max([m,0.1]);

plot(ax1, log_watts(li1:li2,1)-timespan(1), log_watts(li1:li2,2), 'Color', [0.6,0.6,0.6], 'LineWidth', 2, 'DisplayName', 'Raw data');
plot(ax1, t1-timespan(1), y1, 'Color', 'b', 'LineWidth', 2, 'DisplayName', 'PWC denoising');
plot(ax1, t2-timespan(1), ones(1,length(t2))*(m+0.19), 'v', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'DisplayName', 'Events');
xlim(timespan-timespan(1));
ylim([m-0.1,m+0.7]);

xlabel('Time / s');
ylabel('Power / kW');
legend('show');

end

