function [ event_queue, sensor_state, packet_state ] = simu_packet_finish( time, v, event_queue, sensor_state, packet_state )
%SIMU_PACKET_FINISH Summary of this function goes here
%   Detailed explanation goes here

packet_state{v.pktid}.finished = time;
sensor_state{packet_state{v.pktid}.id}.busy_till = 0;

end

