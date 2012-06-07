[demuxed_events, evt_id_map] = demux_recv_events(recvevents);

clear('ax');
figure;
for i=1:size(evt_id_map,1)
    t = demuxed_events(evt_id_map(i,2)).events;
    ax(i) = subplot(ceil(size(evt_id_map,1)/3),3,i);
    d = [];
    hold on;
    flag = t(1,2);
    for j=1:size(t,1)
        if t(j,2) > 1
            plot([t(j,1)-0.1 t(j,1)], [0.5 t(j,2)-2], 'red');
            continue;
        end
        if isempty(d)
            d = [recvevents(1).timestamp 1-t(j,2); t(j,1)-0.1 1-t(j,2); t(j,1) t(j,2)];
        end
        if t(j,2) == flag && j>1
            plot(d(:,1), d(:,2));
            display('lost event!');
            d = [t(j,1)-0.1 1-t(j,2); t(j,1) t(j,2)];
        else
            d(end+1,:) = [t(j,1)-0.1 flag];
            d(end+1,:) = [t(j,1) t(j,2)];
            flag = t(j,2);
        end
    end
    d(end+1,:) = [recvevents(end).timestamp flag];
    plot(d(:,1), d(:,2));
    title(['#' num2str(demuxed_events(evt_id_map(i,2)).id)]);
    ylim([-0.2 1.2]);
end
%%
linkaxes([ax_main ax], 'x');
