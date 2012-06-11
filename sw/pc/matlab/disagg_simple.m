
revt_pnt = 1;
disagg_events = cell(0,1);
combined_events = cell(0,1);

while revt_pnt <= length(recvevents)
    curr_revt = recvevents(revt_pnt);
%    tmp = revt_pnt+1;
%    while tmp <= length(recvevents)
%        if recvevents(tmp).timestamp - curr_revt.timestamp > 15
%            break;
%        end
%        tmp = tmp+1;
%    end
%    w = zeros(0,1);
%    for i = revt_pnt:(tmp-1)
%        w = [w; recvevents(i).watts_events(:,1)];
%    end
%    w = unique(w);
%    dpower = 0;
%    for i = w'
%        dpower = dpower + wattsevents(i).delta_watts;
%    end
%    [combined_events, cid, parsed_revts] = log_combined_event(recvevents(revt_pnt:(tmp-1)), dpower, combined_events);
    [combined_events, cid, parsed_revts, revt_pnt_new, dpower, w] = log_combined_event(recvevents, wattsevents, revt_pnt, combined_events);
    if cid
        disp(['Combined recvevents: ' num2str(revt_pnt) '-' num2str(revt_pnt_new-1)]);
        for i = 1:length(parsed_revts)
            if parsed_revts(i).event == 0
                status = 2;
            elseif parsed_revts(i).event == 1
                status = 3;
            end
            disagg_events = log_disagg_event(parsed_revts(i).id, parsed_revts(i).timestamp, cid, status, disagg_events);
        end
    elseif ~isempty(parsed_revts)
        if length(w) > 1
            t1 = wattsevents(w(1)).timestamp;
            t2 = wattsevents(w(end)).timestamp;
            disp(['Combining multiple wattsevent: id=' num2str(w(1)) '-' num2str(w(end)) ' timespan=' num2str(t2-t1) ' revtid=' num2str(revt_pnt) '-' num2str(revt_pnt_new-1)]);
        elseif isempty(w)
            disp(['No wattsevent: revtid=' num2str(revt_pnt) '-' num2str(revt_pnt_new-1)]);
        end
        if parsed_revts.event == 0
            status = 0;
        elseif parsed_revts.event == 1
            status = 1;
        end
        disagg_events = log_disagg_event(parsed_revts.id, parsed_revts.timestamp, dpower, status, disagg_events);
    end
    revt_pnt = revt_pnt_new;
end

disagg_events = fix_combined_events_hisonly( disagg_events, combined_events );

