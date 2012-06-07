function [ output_args ] = recv_event_stat_core( logfile )
%RECV_EVENT_STAT_CORE Summary of this function goes here
%   Detailed explanation goes here

sensors = [1:22];

[r, rawdata, wrongpkts, stat] = parse_event(logfile, sensors);

y = [stat(:,1)./stat(:,2) stat(:,3)./stat(:,4)];
y(isnan(y)) = 0.5;
%y(:,2) = y(:,2)-y(:,1);
overall = sum(stat, 1);
display(['Overall packet: ',num2str(overall(1)),'/',num2str(overall(2)),' ( ',num2str(overall(1)/overall(2)*100),'% )']);
display(['Overall event: ',num2str(overall(3)),'/',num2str(overall(4)),' ( ',num2str(overall(3)/overall(4)*100),'% )']);

figure;
bar(y, 'BaseValue', 0.5, 'BarWidth', 1);
colormap('summer');
ylim([0.5 1.05]);
xlim([0 23]);

end

