function plot_ground_truth( channel, axs )
%PLOT_GROUND_TRUTH Summary of this function goes here
%   Detailed explanation goes here
path='panel-0522';

figure;

truth = load([path '/truth/' num2str(channel) '.log']);
ax(1) = subplot(2,1,1);
plot(truth(:,1), truth(:,2));

kwsep = load([path '/kw-sep.log']);
t = load([path '/time.log']);

ax(2) = subplot(2,1,2);
plot(t, kwsep(:,[4 10 12 13]));

%linkaxes([ax1 ax2], 'x');
try
    linkaxes([ax axs], 'x');
catch
    linkaxes(ax, 'x');
end

end

