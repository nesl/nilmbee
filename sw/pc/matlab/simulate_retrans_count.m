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

logfile_base = 'simulation-result/retrans-count/log-';

%%

for i=1:length(eventfiles)
    eventfile = [eventfile_base eventfiles{i} '.txt'];
    logfile_base1 = [logfile_base eventfiles{i} '-'];
    for retrans_count=0:4
        for pkt_delivery_rate = [0.4 0.6 0.8 1]
            logfile = [logfile_base1 'retrans' num2str(retrans_count) '-pdr' num2str(pkt_delivery_rate) '.txt'];
            disp(logfile);
            event_q = init_simulator(eventfile, rand(), 0.036, retrans_count, pkt_delivery_rate);
            pkt_state = packet_simulator(event_q);
            output_simulator(pkt_state, logfile);
        end
    end
end

%%

dim1 = length(eventfiles);
dim2 = 5; % retrans_count 0:4
dim3 = 4; % pdr 0.4:0.2:1

pdr = zeros(dim1, dim2, dim3);
edr = zeros(dim1, dim2, dim3);

for i=1:length(eventfiles)
    eventfile = [eventfile_base eventfiles{i} '.txt'];
    logfile_base1 = [logfile_base eventfiles{i} '-'];
    for retrans_count=0:4
        j = retrans_count + 1;
        for pkt_delivery_rate = [0.4 0.6 0.8 1]
            k = pkt_delivery_rate * 5 - 1;
            logfile = [logfile_base1 'retrans' num2str(retrans_count) '-pdr' num2str(pkt_delivery_rate) '.txt'];
            disp(logfile);
            r = match_event_core(eventfile, logfile, retrans_count);
            edr(i,j,k) = r(end-1,3);
            pdr(i,j,k) = r(end,3);
        end
    end
end

save(['simulation-result/retrans-count-' dataset_name '.mat'], 'pdr', 'edr');

%%

dim1 = length(eventfiles);
dim2 = 5; % retrans_count 0:4
dim3 = 4; % pdr 0.4:0.2:1
load(['simulation-result/retrans-count-' dataset_name '.mat'], 'pdr', 'edr');

for pkt_delivery_rate = [0.4 0.6 0.8 1]
    k = pkt_delivery_rate * 5 - 1;

    % Create figure
    figure1 = figure('PaperPositionMode', 'auto', 'Position', [100 100 800 400]);
    figure2 = figure('PaperPositionMode', 'auto', 'Position', [100 100 800 400]);
    % Create axes
    axes1 = axes('Parent',figure1,'YGrid','on','FontSize',12);
    hold(axes1,'all');
    axes2 = axes('Parent',figure2,'YGrid','on','FontSize',12);
    hold(axes2,'all');
    
    edrtrace = zeros(10,0);
    pdrtrace = zeros(10,0);
    for retrans_count=0:4
        j = retrans_count + 1;
        edrtrace = [edrtrace edr(:,j,k)];
        pdrtrace = [pdrtrace pdr(:,j,k)];
    end
    % Create multiple lines using matrix input to plot
    plot1 = plot([3 4 5 6 7 8 10 12 15 20],edrtrace,'Parent',axes1,'LineWidth',2);
    plot2 = plot([3 4 5 6 7 8 10 12 15 20],pdrtrace,'Parent',axes2,'LineWidth',2);
    set(plot1(1),'Marker','o',...
        'Color',[0.380392163991928 0.380392163991928 0.380392163991928],...
        'DisplayName','1 pkt');
    set(plot1(2),'Marker','+',...
        'Color',[0.529411792755127 0.317647069692612 0.317647069692612],...
        'DisplayName','2 pkt');
    set(plot1(3),'MarkerSize',8,'Marker','x',...
        'Color',[0.39215686917305 0.474509805440903 0.635294139385223],...
        'DisplayName','3 pkt');
    set(plot1(4),'Marker','o','LineStyle','--',...
        'Color',[0.470588237047195 0.30588236451149 0.447058826684952],...
        'DisplayName','4 pkt');
    set(plot1(5),'MarkerSize',8,'Marker','x','LineStyle','--',...
        'Color',[0.164705887436867 0.384313732385635 0.274509817361832],...
        'DisplayName','5 pkt');

    set(plot2(1),'Marker','o',...
        'Color',[0.380392163991928 0.380392163991928 0.380392163991928],...
        'DisplayName','1 pkt');
    set(plot2(2),'Marker','+',...
        'Color',[0.529411792755127 0.317647069692612 0.317647069692612],...
        'DisplayName','2 pkt');
    set(plot2(3),'MarkerSize',8,'Marker','x',...
        'Color',[0.39215686917305 0.474509805440903 0.635294139385223],...
        'DisplayName','3 pkt');
    set(plot2(4),'Marker','o','LineStyle','--',...
        'Color',[0.470588237047195 0.30588236451149 0.447058826684952],...
        'DisplayName','4 pkt');
    set(plot2(5),'MarkerSize',8,'Marker','x','LineStyle','--',...
        'Color',[0.164705887436867 0.384313732385635 0.274509817361832],...
        'DisplayName','5 pkt');
    
    % Create label
    xlabel(axes1,'\mu (s)','FontSize',14);
    ylabel(axes1,'Event delivery ratio','FontSize',14);

    xlabel(axes2,'\mu (s)','FontSize',14);
    ylabel(axes2,'Packet delivery ratio','FontSize',14);

    % Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','SouthEastOutside','FontSize',12);

    legend2 = legend(axes2,'show');
    set(legend2,'Location','SouthEastOutside','FontSize',12);
    
    print(figure1, ['simulation-result/retrans-count-edr-' dataset_name '-pdr' num2str(pkt_delivery_rate) '.eps'], '-depsc');
    print(figure2, ['simulation-result/retrans-count-pdr-' dataset_name '-pdr' num2str(pkt_delivery_rate) '.eps'], '-depsc');
end

