function [ event_queue, sensor_state, packet_state ] = simu_cycle_tick( time, v, event_queue, sensor_state, packet_state )
%SIMU_CYCLE_TICK Summary of this function goes here
%   Detailed explanation goes here

PACKET_LENGTH = 0.064;

for i=1:length(sensor_state)
    if isempty(sensor_state{i}); continue; end
    if sensor_state{i}.busy_till; continue; end
    if sensor_state{i}.delay_count
        s = sensor_state{i};
        s.delay_count = s.delay_count - 2;
        if s.delay_count == s.next_delay
            % insert new packet
            pkt = struct();
            pkt.id = i;
            pkt.event = s.event;
            pkt.grp = s.grp;
            pkt.slot = s.slot;
            pkt.seq = s.seq;
            s.seq = mod(s.seq + 1, 16);
            pkt.dirty = 0;
            pkt.finished = 0;
            packet_state{end+1} = pkt;
            [ packet_state ] = simu_collision_test( time, packet_state );
            
            % insert packet finish event
            e = struct();
            e.type = 2;
            e.pktid = length(packet_state);
            simu_enqueue(time + PACKET_LENGTH, e, event_queue);
            
            % update next packet info
            s.grp = s.grp - 1;
            s.slot = randi([0,7]);
            if s.grp == 0 && s.slot == 0; s.slot = 1; end
            s.next_delay = s.grp * 64 + s.slot * 8;
            s.busy_till = time + PACKET_LENGTH;
        end
        sensor_state{i} = s;
    end
end

% insert next tick
if ~isempty(event_queue)
    e = struct();
    e.type = 0;
    e.cycle = v.cycle + 1;
    simu_enqueue(e.cycle/60, e, event_queue);
    %if mod(v.cycle, 600) == 0
    %    disp(['Time:' num2str(time)]);
    %end
end

end

