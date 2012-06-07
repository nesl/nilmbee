app_watts_map = train_single_event( wattsevents, recvevents );

app_watts = cell(100,1);
% match events
for i=1:length(wattsevents)
    tw = wattsevents(i);
    if ~isempty(tw.recv_event)
        flag = 1; w = 0; s2 = 0;
        for j=1:length(tw.recv_event)
            tr = recvevents(tw.recv_event(j));
            if ~app_watts_map(tr.id,tr.event+1)
                flag = 0;
                break;
            end
            w = w + app_watts_map(tr.id,tr.event+1);
            s2 = s2 + 0.01 * app_watts_map(tr.id,tr.event+1) * app_watts_map(tr.id,tr.event+1);
        end
        if ~flag || abs(tw.delta_watts - w) > sqrt(s2)
            flag = 0;
        end
        if flag
            for j=1:length(tw.recv_event)
                tr = recvevents(tw.recv_event(j));
                d = app_watts_map(tr.id,tr.event+1) / w * tw.delta_watts;
                app_watts{tr.id}(end+1,:) = [tw.timestamp, d];
            end
        else
            display(['Can not desaggregate watts-event ' num2str(i) ' based on current knowledge']);
        end
    else
        display(['Can not desaggregate watts-event ' num2str(i) '. No recv events.']);
    end
end

% plot
figure;
s=1;
for i=1:length(app_watts)
    if isempty(app_watts{i})
        continue;
    end
    
    d = [log_watts(1,1) 0];
    y = 0;
    for j=1:size(app_watts{i},1)
        d(end+1,:) = [app_watts{i}(j, 1)-0.1 y];
        y = y + app_watts{i}(j, 2);
        d(end+1,:) = [app_watts{i}(j, 1) y];
    end
    d(end+1,:) = [log_watts(end,1) y];
    subplot(6,1,s);
    plot(d(:,1), d(:,2));
    title(['#' num2str(i)]);
    s=s+1;
end


