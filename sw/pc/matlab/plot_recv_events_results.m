[demuxed_events, evt_id_map] = demux_recv_events(recvevents);

timespan = [recvevents(1).timestamp recvevents(end).timestamp];
ids = [1 2 3 5 8 12 13 14 17 18 21];
for i=1:size(evt_id_map,1)
%for i=[1 2]
    %if ~any(ids==evt_id_map(i,1)); continue; end
    if ~any([4 6 7 9 11 15 16 19 22]==evt_id_map(i,1)); continue; end
    states = get_state_by_recv(demuxed_events(evt_id_map(i,2)), timespan);

    f(i) = figure('Position', [300,300,800,200], 'PaperPositionMode','auto');

    %truth = load([path '/truth/' num2str(evt_id_map(i,1)) '.log']);
    %t = plot(truth(:,1)-timespan(1), truth(:,2)/1000, 'b', 'LineWidth', 2);
    %yl = ylim * 1.1;
    %time_on = get_on_time_from_power(truth, 5);
    yl=[0 1];
    
    hold on;
    time_correct = 0;
    time_report_on = 0;
    for j=1:size(states,1)
        x = [states(j,1) states(j,1) states(j,2) states(j,2)];
        y = [yl(2) yl(1) yl(1) yl(2)];
        if states(j,3) == 1
            patch(x-timespan(1),y,[0.6 0.6 0.6], 'EdgeColor','none');
            i1 = find(truth(:,1)>states(j,1), 1, 'first');
            i2 = find(truth(:,1)<states(j,2), 1, 'last');
            %time_correct = time_correct + get_on_time_from_power(truth(i1:i2,:), 5);
            time_report_on = time_report_on + states(j,2) - states(j,1);
        elseif states(j,3) == -1
            patch(x-timespan(1),y,'red', 'EdgeColor','none');
        end
    end
    
    %if ~isempty(truth)
    %    uistack(t, 'top');
    %end
    
    title(['#' num2str(demuxed_events(evt_id_map(i,2)).id)]);
    ylim(yl);
    xlim(timespan-timespan(1));
    ylabel('Power / kW');
    xlabel('Time / s');
    
    disp(['#' num2str(demuxed_events(evt_id_map(i,2)).id) ' ton=' num2str(time_on)  ' tron=' num2str(time_report_on)  ' tc=' num2str(time_correct) ' p=' num2str(time_correct/time_report_on) ' r=' num2str(time_correct/time_on)]);
    %print(f(i), ['disagg-result/state-' num2str(demuxed_events(evt_id_map(i,2)).id) '.eps'], '-depsc');
end
