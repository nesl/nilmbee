s = zeros(7,0);
s1=s;

dataset_name = '5min';
eventfile_base = ['event-dataset/' dataset_name '/'];

eventfiles = { ...
    ['event-' dataset_name '-3'], ...
    ['event-' dataset_name '-4'], ...
    ['event-' dataset_name '-5'], ...
    ['event-' dataset_name '-6'], ...
    ['event-' dataset_name '-7'], ...
    ['event-' dataset_name '-8'], ...
    ['event-' dataset_name '-10'], ...
    ['event-' dataset_name '-12'], ...
    ['event-' dataset_name '-15'], ...
    ['event-' dataset_name '-20'] ...
    };

logfile_base = 'testbed-result/log-';

%%

for i=1:length(eventfiles)
    eventfile = [eventfile_base eventfiles{i} '.txt'];
    logfile = [logfile_base eventfiles{i} '.txt'];
    r = match_event_core(eventfile, logfile, 4);
    s = [s r(:,3)];
end

%%
eventfile = '3event-0.0.txt';
logfile = 'testbed-result/log-3event.0.0';
r = match_event_core(eventfile, logfile, 4);
s1 = [s1 r(:,3)];

%%
eventfile = '3event-0.2.txt';
logfile = 'testbed-result/log-3event.0.2';
r = match_event_core(eventfile, logfile, 4);
s1 = [s1 r(:,3)];

%%
eventfile = '3event-0.4.txt';
logfile = 'testbed-result/log-3event.0.4';
r = match_event_core(eventfile, logfile, 4);
s1 = [s1 r(:,3)];

%%

t = [3 4 5 6 7 8 10 12 15 20];
fig1 = figure('PaperPositionMode', 'auto', 'Position', [100 100 600 400]); 
axes('YGrid','on','FontSize',12);
hold;
pt = plot(t, s(1,:), ':x', 'DisplayName','EDR of sensors');
plot(t, s(2,:), ':x');
plot(t, s(3,:), ':x');
plot(t, s(4,:), ':x');
plot(t, s(5,:), ':x');
plot(t, s(6,:), ':x');

pedr = plot(t, s(7,:), 'LineWidth', 2, 'DisplayName','EDR average', 'Marker','o','MarkerSize',6,...
    'Color',[0.380392163991928 0.380392163991928 0.380392163991928]);
ppdr = plot(t, s(8,:), 'LineWidth', 2, 'DisplayName','PDR average', 'Marker','+','MarkerSize',8,...
    'Color',[0.529411792755127 0.317647069692612 0.317647069692612]);

xlabel('\mu (s)','FontSize',14);
ylabel('Delivery ratio','FontSize',14);
legend1 = legend([pedr ppdr pt]);
set(legend1,'Location','SouthEast','FontSize',12);
print(fig1, ['testbed-result/poisson-' dataset_name '.eps'], '-depsc');

%%

t = [0 0.2 0.4];
fig2 = figure('PaperPositionMode', 'auto', 'Position', [100 100 600 400]); 
axes('YGrid','on','FontSize',12);
hold;
%plot(t, s1(1,:), '--o');
%plot(t, s1(2,:), '--o');
%plot(t, s1(3,:), '--o');
plot(t, s1(4,:), 'LineWidth', 2, 'DisplayName','EDR', 'Marker','o','MarkerSize',6,...
    'Color',[0.380392163991928 0.380392163991928 0.380392163991928]);
plot(t, s1(5,:), 'LineWidth', 2, 'DisplayName','EDR', 'Marker','+','MarkerSize',8,...
    'Color',[0.529411792755127 0.317647069692612 0.317647069692612]);
ylim([0.4 1.02]);
xlabel('Time between collided events (s)','FontSize',14);
ylabel('Delivery ratio','FontSize',14);
legend1 = legend('show');
set(legend1,'Location','SouthEast','FontSize',12);
print(fig2, ['testbed-result/collision.eps'], '-depsc');
