function plot_packet_state( pkt_state )
%PLOT_PACKET_STATE Summary of this function goes here
%   Detailed explanation goes here

figure;
hold on;
for i=1:length(pkt_state)
    if pkt_state{i}.grp + pkt_state{i}.slot
        color = 'b';
    else
        color = 'k';
    end
    line([pkt_state{i}.finished, pkt_state{i}.finished-0.064], [pkt_state{i}.id pkt_state{i}.id], 'Color', color, 'LineWidth', 1.5);
    if pkt_state{i}.dirty
        line([pkt_state{i}.finished, pkt_state{i}.finished-0.064], [pkt_state{i}.id-0.05 pkt_state{i}.id-0.05], 'Color', 'r', 'LineWidth', 1.5);
    end
end
ylim([-1,7]);

end

