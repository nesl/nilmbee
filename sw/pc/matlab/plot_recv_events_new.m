[demuxed_events, evt_id_map] = demux_recv_events(recvevents);

clear('ax');
figure;
timespan = [recvevents(1).timestamp recvevents(end).timestamp];
for i=1:size(evt_id_map,1)
    states = get_state_by_recv(demuxed_events(evt_id_map(i,2)), timespan);

    ax(i) = subplot(ceil(size(evt_id_map,1)/3),3,i);

    truth = [];
    try
        truth = load([path '/truth/' num2str(evt_id_map(i,1)) '.log']);
        t = plot(truth(:,1), truth(:,2)/1000, 'blue');
        yl = ylim * 1.1;
    catch
        yl = [-0.2, 1.2];
    end
    
    hold on;
    for j=1:size(states,1)
        x = [states(j,1) states(j,1) states(j,2) states(j,2)];
        y = [yl(2) yl(1) yl(1) yl(2)];
        if states(j,3) == 1
            patch(x,y,'yellow', 'EdgeColor','none');
        elseif states(j,3) == -1
            patch(x,y,'red', 'EdgeColor','none');
        end
    end
    
    if ~isempty(truth)
        uistack(t, 'top');
    end
    
    title(['#' num2str(demuxed_events(evt_id_map(i,2)).id)]);
    ylim(yl);
end
%%
linkaxes([ax_main ax], 'x');
