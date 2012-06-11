%path='panel-0524';

disagg_map = zeros(0,2);
for i=1:length(disagg_events)
    disagg_map = [disagg_map; disagg_events{i}.id i];
end
[~, idx] = sort(disagg_map(:,1));
disagg_map = disagg_map(idx, :);

figure;
timespan = [recvevents(1).timestamp recvevents(end).timestamp];
axd = [];
for i=1:size(disagg_map,1)
    axd(i) = subplot(ceil(size(disagg_map,1)/3), 3, i);
    e_real = 0;
    try
        truth = load([path '/truth/' num2str(disagg_map(i,1)) '.log']);
        plot(truth(:,1), truth(:,2)/1000, 'red');
        i1 = find(truth(:,1)>timespan(1), 1, 'first');
        i2 = find(truth(:,1)<timespan(2), 1, 'last');
        e_real = get_energy_from_truth(truth(i1:i2, :));
    end
    hold on;
    e_est = plot_disagg_single(disagg_events{disagg_map(i,2)}, timespan, axd(i));
    e_est = e_est / 3.6;
    
    title(['#' num2str(disagg_map(i,1))]);
    disp(['#' num2str(disagg_map(i,1)) ' est:' num2str(e_est) ' real:' num2str(e_real) ' err:' num2str(abs(e_est/e_real-1))]);
end

linkaxes([axd ax_main ax], 'x');
