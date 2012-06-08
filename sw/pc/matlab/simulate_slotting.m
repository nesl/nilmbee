dataset_name = '250evt';
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

logfile_base = 'simulation-result/slotting/log-';

%%

for i=1:length(eventfiles)
    eventfile = [eventfile_base eventfiles{i} '.txt'];
    logfile_base1 = [logfile_base eventfiles{i} '-'];

    logfile = [logfile_base1 'async.txt'];
    disp(logfile);
    event_q = init_simulator_async(eventfile, rand(), 0.036, 4, 1);
    pkt_state = packet_simulator_async(event_q);
    output_simulator(pkt_state, logfile);

    logfile = [logfile_base1 '1cyc.txt'];
    disp(logfile);
    event_q = init_simulator(eventfile, rand(), 0.036, 4, 1);
    pkt_state = packet_simulator(event_q);
    output_simulator(pkt_state, logfile);

    logfile = [logfile_base1 '4cyc.txt'];
    disp(logfile);
    event_q = init_simulator_4cyc(eventfile, rand(), 0.036, 4, 1);
    pkt_state = packet_simulator_4cyc(event_q);
    output_simulator(pkt_state, logfile);
end

%%

dim1 = length(eventfiles);
dim2 = 3; % async 1cyc 4cyc

pdr = zeros(dim1, dim2);
edr = zeros(dim1, dim2);

for i=1:length(eventfiles)
    eventfile = [eventfile_base eventfiles{i} '.txt'];
    logfile_base1 = [logfile_base eventfiles{i} '-'];

    logfile = [logfile_base1 'async.txt'];
    disp(logfile);
    r = match_event_core(eventfile, logfile, retrans_count);
    edr(i,1) = r(end-1,3);
    pdr(i,1) = r(end,3);

    logfile = [logfile_base1 '1cyc.txt'];
    disp(logfile);
    r = match_event_core(eventfile, logfile, retrans_count);
    edr(i,2) = r(end-1,3);
    pdr(i,2) = r(end,3);

    logfile = [logfile_base1 '4cyc.txt'];
    disp(logfile);
    r = match_event_core(eventfile, logfile, retrans_count);
    edr(i,3) = r(end-1,3);
    pdr(i,3) = r(end,3);
end

save(['simulation-result/slotting-' dataset_name '.mat'], 'pdr', 'edr');

%%

dim1 = length(eventfiles);
dim2 = 3; % async 1cyc 4cyc
load(['simulation-result/slotting-' dataset_name '.mat'], 'pdr', 'edr');

% Create figure
figure1 = figure('PaperPositionMode', 'auto', 'Position', [100 100 700 400]);
figure2 = figure('PaperPositionMode', 'auto', 'Position', [100 100 700 400]);
% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','FontSize',12);
hold(axes1,'all');
axes2 = axes('Parent',figure2,'YGrid','on','FontSize',12);
hold(axes2,'all');

% Create multiple lines using matrix input to plot
plot1 = plot([3 4 5 6 7 8 10 12 15 20],edr,'Parent',axes1,'LineWidth',2);
plot2 = plot([3 4 5 6 7 8 10 12 15 20],pdr,'Parent',axes2,'LineWidth',2);
set(plot1(1),'Marker','o',...
    'Color',[0.380392163991928 0.380392163991928 0.380392163991928],...
    'DisplayName','Async');
set(plot1(2),'Marker','+',...
    'Color',[0.529411792755127 0.317647069692612 0.317647069692612],...
    'DisplayName','1 Cycle');
set(plot1(3),'MarkerSize',8,'Marker','x',...
    'Color',[0.39215686917305 0.474509805440903 0.635294139385223],...
    'DisplayName','4 Cycle');

set(plot2(1),'Marker','o',...
    'Color',[0.380392163991928 0.380392163991928 0.380392163991928],...
    'DisplayName','Async');
set(plot2(2),'Marker','+',...
    'Color',[0.529411792755127 0.317647069692612 0.317647069692612],...
    'DisplayName','1 Cycle');
set(plot2(3),'MarkerSize',8,'Marker','x',...
    'Color',[0.39215686917305 0.474509805440903 0.635294139385223],...
    'DisplayName','4 Cycle');

% Create label
xlabel(axes1,'\mu (s)','FontSize',14);
ylabel(axes1,'Event delivery ratio','FontSize',14);
ylim(axes1, [0.84 1]);

xlabel(axes2,'\mu (s)','FontSize',14);
ylabel(axes2,'Packet delivery ratio','FontSize',14);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','SouthEast','FontSize',12);

legend2 = legend(axes2,'show');
set(legend2,'Location','SouthEast','FontSize',12);

print(figure1, ['simulation-result/slotting-edr-' dataset_name '.eps'], '-depsc');
print(figure2, ['simulation-result/slotting-pdr-' dataset_name '.eps'], '-depsc');


