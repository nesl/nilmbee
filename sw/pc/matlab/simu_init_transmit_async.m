function [ event_queue, sensor_state, packet_state ] = simu_init_transmit_async( time, v, event_queue, sensor_state, packet_state )
%SIMU_INIT_TRANSMIT Summary of this function goes here
%   Detailed explanation goes here

PACKET_LENGTH = 0.064;

s = sensor_state{v.id};

if ~isempty(s) && s.busy_till
    % device busy, reinsert the event
    event_queue(s.busy_till + 0.00001) = v;
    return;
end
if isempty(s)
    s.id = v.id;
    s.seq = 0;
    s.pkt_delivery_rate = v.pkt_delivery_rate;
    s.next_transmit = 0;
end
if s.next_transmit
    % remove pending packet
    remove(event_queue, s.next_transmit);
end

% insert new packet
pkt = struct();
pkt.id = v.id;
pkt.event = v.event;
pkt.grp = 0;
pkt.slot = 0;
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
s.event = v.event;
s.grp = 3;
s.slot = randi([0,7]);
%s.next_delay = s.grp * 64 + s.slot * 8;
%s.delay_count = 256;
s.busy_till = time + PACKET_LENGTH;

delay_after = (32 - s.grp*8 - s.slot) / 15;
e = struct();
e.type = 3;
e.id = v.id;
[event_queue, k] = simu_enqueue(time + delay_after, e, event_queue);
s.next_transmit = k;

sensor_state{v.id} = s;

end

