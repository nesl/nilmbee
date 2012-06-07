[demuxed_events, evt_id_map] = demux_recv_events(recvevents);

figure;
for i=1:size(evt_id_map,1)
    id = evt_id_map(i,1);
    t = demuxed_events(evt_id_map(i,2)).events;
    pwrchange = cell(1,2);
    for j=1:size(t,1)
        if recvevents(t(j,3)).watts_event(1) == 0
            continue
        end
        w = wattsevents(recvevents(t(j,3)).watts_event(1));
        if t(j,2) == 0
            pwrchange{1} = [pwrchange{1}; w.delta_watts];
        elseif t(j,2) == 1
            pwrchange{2} = [pwrchange{2}; w.delta_watts];
        end
    end
    subplot(ceil(size(evt_id_map,1)/3),3,i);
    hold on;
    scatter(pwrchange{1},random('unif', -0.1, 0.1,length(pwrchange{1}),1),5,'blue');
    scatter(pwrchange{2},random('unif', -0.1, 0.1,length(pwrchange{2}),1),5,'red');
    title(['#' num2str(demuxed_events(evt_id_map(i,2)).id)]);
end
