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
    try
        truth = load([path '/truth/' num2str(disagg_map(i,1)) '.log']);
        plot(truth(:,1), truth(:,2)/1000, 'red');
    end
    hold on;
    plot_disagg_single(disagg_events{disagg_map(i,2)}, timespan, axd(i));
    
    title(['#' num2str(disagg_map(i,1))]);
end

linkaxes([axd ax_main ax], 'x');
