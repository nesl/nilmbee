function [ events, raw, wrongpkts, stat ] = parse_event( logfile, sensors, retrans_count )
%PARSE_EVENT Parse log file and output received events.
%   

indata = load(logfile);
t = [];
events = zeros(0, 4);
wrongpkts = 0;
for i=1:size(indata,1)
    d = indata(i,:);
    
    [e, t, newevent] = parse_event_online_retrans(d, sensors, t, retrans_count);
    
    indata(i,7) = newevent;
    
    if newevent
        events = [events; e];
    end
    
end

raw = indata;
stat = t(:,7:10);

end

