timespan = [wattsevents(1).timestamp wattsevents(end).timestamp];

%for i=1:5
%    t = timespan(1) + (timespan(2)-timespan(1))*rand();
%    plot_pwc_result_core(log_watts, wattsevents, recvevents, [t, t+300]);
%end
%log_watts2 = log_watts;
%log_watts2(:,2) = medfilt1(log_watts(:,2), 5);
for t=[1338847010 1338840636 1338843079 1339034147 1338922657]
    plot_pwc_result_core(log_watts, wattsevents, recvevents, [t, t+1500]);
end
