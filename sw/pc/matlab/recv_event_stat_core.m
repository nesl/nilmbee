function [ figure1, stat_all ] = recv_event_stat_core( logfiles )
%RECV_EVENT_STAT_CORE Summary of this function goes here
%   Detailed explanation goes here

sensors = [1:22];
stat_all = zeros(22,4);

for logfile = logfiles

    [r, rawdata, wrongpkts, stat] = parse_event(logfile{1}, sensors, 4);
    
    stat_all = stat_all + stat;
end

y = [stat_all(:,1)./stat_all(:,2) stat_all(:,3)./stat_all(:,4)];
y(isnan(y)) = 0.5;
%y(:,2) = y(:,2)-y(:,1);
overall = sum(stat, 1);
display(['Overall packet: ',num2str(overall(1)),'/',num2str(overall(2)),' ( ',num2str(overall(1)/overall(2)*100),'% )']);
display(['Overall event: ',num2str(overall(3)),'/',num2str(overall(4)),' ( ',num2str(overall(3)/overall(4)*100),'% )']);

figure1 = figure('Position', [100 100 1000 400], 'PaperPositionMode', 'auto');
colormap('summer');
axes1 = axes('YGrid','on', 'FontSize',12);
box(axes1,'on');
hold(axes1,'all');

bar1 = bar(y, 'BaseValue', 0.5, 'BarWidth', 1);
set(bar1(1),'DisplayName','PDR');
set(bar1(2),'DisplayName','EDR');

ylim([0.5 1.05]);
xlim([0 23]);

% Create xlabel
xlabel('Sensor ID','FontSize',12);

% Create ylabel
ylabel('Delivery ratio','FontSize',12);
legend1 = legend(axes1, 'show');
set(legend1,'Location','SouthEast','FontSize',12);

end

