%path='panel-0524';

disagg_map = zeros(0,2);
for i=1:length(disagg_events)
    disagg_map = [disagg_map; disagg_events{i}.id i];
end
[~, idx] = sort(disagg_map(:,1));
disagg_map = disagg_map(idx, :);

timespan = [recvevents(1).timestamp recvevents(end).timestamp];
axd = [];
ids = [5 8 12 13 14 17 18 21];
for i=1:size(disagg_map,1)
    if ~any(5==disagg_map(i,1)); continue; end
    f(i) = figure('Position', [300,300,800,200], 'PaperPositionMode','auto');
    axd(end+1) = axes;
    hold on;
    e_real = 0;
    try
        truth = load([path '/truth/' num2str(disagg_map(i,1)) '.log']);
        plot(truth(:,1)-timespan(1), truth(:,2)/1000, 'Color', [0.6,0.6,0.6], 'LineWidth', 2, 'DisplayName', 'truth');
        i1 = find(truth(:,1)>timespan(1), 1, 'first');
        i2 = find(truth(:,1)<timespan(2), 1, 'last');
        e_real = get_energy_from_truth(truth(i1:i2, :));
    end
    [e_est, p] = plot_disagg_single(disagg_events{disagg_map(i,2)}, timespan, axd(end));
    e_est = e_est / 3.6;
    set(p, 'Color', 'b', 'LineWidth', 2, 'DisplayName', 'estimation');
    
    title(['#' num2str(disagg_map(i,1))]);
    xlim(timespan-timespan(1));
    xlabel('Time / s');
    ylabel('Power / kW');
    legend('show');
    
    disp(['#' num2str(disagg_map(i,1)) ' est:' num2str(e_est) ' real:' num2str(e_real) ' err:' num2str(abs(e_est/e_real-1))]);
end

linkaxes(axd, 'x');
linkaxes([axd ax_main], 'x');
