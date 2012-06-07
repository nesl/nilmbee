function output_simulator( packet_state, output_file )
%OUTPUT_SIMULATOR Summary of this function goes here
%   Detailed explanation goes here

dirty_s = zeros(1,25);
clean_s = zeros(1,25);
clean_packets = 0;

fid = fopen(output_file, 'w');
for i=1:length(packet_state)
    p = packet_state{i};
    if p.dirty
        dirty_s(p.id) = dirty_s(p.id) + 1;
    else
        clean_s(p.id) = clean_s(p.id) + 1;
        clean_packets = clean_packets + 1;
        fprintf(fid, '%f %d %d %d %d %d\n', p.finished, p.id, p.grp, p.slot, p.seq, p.event);
    end
end
fclose(fid);

for i=1:length(dirty_s)
    if dirty_s(i)+clean_s(i)
        r = clean_s(i);
        t = dirty_s(i) + clean_s(i);
        disp(['Sensor ' num2str(i) ': ' num2str(r) '/' num2str(t) ' (' num2str(round(r/t*100)) '%)']);
    end
end

r = clean_packets;
t = length(packet_state);
disp(['Overall: ' num2str(r) '/' num2str(t) ' (' num2str(round(r/t*100)) '%)']);
