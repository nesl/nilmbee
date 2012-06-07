function [ event_queue, sensor_state, packet_state ] = simu_retransmit_async( time, v, event_queue, sensor_state, packet_state )
%SIMU_RETRANSMIT_ASYNC Summary of this function goes here
%   Detailed explanation goes here

PACKET_LENGTH = 0.064;

s = sensor_state{v.id};
old_slot = s.grp * 8 + s.slot;

% insert new packet
pkt = struct();
pkt.id = v.id;
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
if s.grp
    s.grp = s.grp - 1;
    s.slot = randi([0,7]);
    if s.grp == 0 && s.slot == 0; s.slot = 1; end

    delay_after = (old_slot - s.grp*8 - s.slot) / 15;
    e = struct();
    e.type = 3;
    e.id = v.id;
    [event_queue, k] = simu_enqueue(time + delay_after, e, event_queue);
    s.next_transmit = k;
else
    s.next_transmit = 0;
end

s.busy_till = time + PACKET_LENGTH;
sensor_state{v.id} = s;

end

