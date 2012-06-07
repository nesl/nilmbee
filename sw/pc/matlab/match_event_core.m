function [results, mismatch] = match_event_core( eventfile, logfile, retrans_count )
%MATCH_EVENT_CORE Compare received events with ground truth
%   !!! Here we assume the first event is always delivered

g = load(eventfile);

sensors = unique(g(:,1));
t = 0;
for i=1:size(g,1)
    d = g(i,3)+0.036;
    g(i,3) = t;
    t = t+d;
end
g(1,4) = 0;

[r,rawdata,wrongpkts,stat] = parse_event(logfile, sensors, retrans_count);
recv_packets_num = size(rawdata, 1);
total_packets = sum(stat(:,2));
[~, i] = sort(r(:,1));
r = r(i,:);
%%removes time offset. not accurate...
%r(:,1) = r(:,1)-r(1,1);

j = 1;
mismatch = 0;
marr_sensor = cell(max(sensors),1);
marr = {};
for i=1:size(r,1)
    tj = j;
    while (g(tj,4) || g(tj,1)~=r(i,2) || g(tj,2)~=r(i,3)) && g(tj,3)-r(i,1)<3
        tj = tj+1;
    end
    if g(tj,3)-r(i,1)>=3
        mismatch = mismatch + 1;
        continue;
    end
    g(tj, 4) = 1;
    marr_sensor{r(i,2)}(end+1) = g(tj,3)-r(i,1);
    marr{end+1} = g(tj,3)-r(i,1);
    while r(i,1) - g(j,3) >=3
        j = j+1;
    end
end

for i=sensors'
    m = marr_sensor{i};
    total = sum(g(:,1)==i);
    tdiffmean = mean(m);
    tdiffvar = var(m);
    %disp(['Sensor #',num2str(i),' :']);
    %disp(['  Total events: ',num2str(total)]);
    %disp(['  Matched events: ',num2str(length(m)),' ( ',num2str(length(m)/total*100),'% )']);
    %disp(['  Time difference mean: ',num2str(tdiffmean)]);
    %disp(['  Time difference var: ',num2str(tdiffvar)]);
    results(i, 1) = total;
    results(i, 2) = length(m);
    results(i, 3) = length(m)/total;
end

m = cell2mat(marr);
total = size(g,1);
tdiffmean = mean(m);
tdiffvar = var(m);
disp('Overall');
disp(['  Total events: ',num2str(total)]);
disp(['  Matched events: ',num2str(length(m)),' ( ',num2str(length(m)/total*100),'% )']);
disp(['  Packet received: ',num2str(recv_packets_num),'/',num2str(total_packets),' ( ',num2str(recv_packets_num/total_packets*100),'% )']);
disp(['  Time difference mean: ',num2str(tdiffmean)]);
disp(['  Time difference var: ',num2str(tdiffvar)]);

disp(['Total mismatched events: ',num2str(mismatch)]);

results(end+1, 1) = total;
results(end, 2) = length(m);
results(end, 3) = length(m)/total;
results(end+1, 3) = recv_packets_num/total_packets;

end

