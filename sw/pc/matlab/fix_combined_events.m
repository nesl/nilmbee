function [ disagg_events ] = fix_combined_events( disagg_events, combined_events )
%FIX_COMBINED_EVENTS Summary of this function goes here
%   Detailed explanation goes here

normwatts = [];
disagg_map = [];
for i=1:length(disagg_events)
    if isempty(disagg_events{i}.abswatts)
        disp(['No single events to infer power of ' num2str(disagg_events{i}.id)]);
        if disagg_events{i}.id == 2; disagg_events{i}.abswatts(end+1) = 0.025; end
    end
    disagg_events{i}.normwatt = median(disagg_events{i}.abswatts);
    normwatts(disagg_events{i}.id) = disagg_events{i}.normwatt;
    disagg_map(disagg_events{i}.id) = i;
end

for i=1:length(combined_events)
    s = 0;
    for j=1:length(combined_events{i}.recvevents)
        if combined_events{i}.recvevents(j).event ==1
            s = s + normwatts(combined_events{i}.recvevents(j).id);
        else
            s = s - normwatts(combined_events{i}.recvevents(j).id);
        end
    end
    if isnan(s)
        disp(['Cannot resolve combined event ' num2str(i) ', no enough data.']);
        continue;
    end
    if s * combined_events{i}.delta_watts < 0
        disp(['Cannot resolve combined event ' num2str(i) ', wrong sign.']);
        continue;
    end
    disp(['Resolving combined event ' num2str(i) ' real delta: ' num2str(combined_events{i}.delta_watts) ' estm delta: ' num2str(s)]);
    r = combined_events{i}.delta_watts / s;
    for j=1:length(combined_events{i}.recvevents)
        t = disagg_map(combined_events{i}.recvevents(j).id);
        for k=1:size(disagg_events{t}.events, 1)
            if disagg_events{t}.events(k,2) == i && disagg_events{t}.events(k,3)>=2
                if combined_events{i}.recvevents(j).event ==1
                    disagg_events{t}.events(k,2) = r * normwatts(combined_events{i}.recvevents(j).id);
                else
                    disagg_events{t}.events(k,2) = - r * normwatts(combined_events{i}.recvevents(j).id);
                end
                disagg_events{t}.events(k,3) = disagg_events{t}.events(k,3) - 2;
            end
        end
    end
end

end

