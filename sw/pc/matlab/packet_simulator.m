function [ packet_state ] = packet_simulator( event_queue )
%PACKET_SIMULATOR Summary of this function goes here
%   Detailed explanation goes here

sensor_state = cell(1,6);
packet_state = cell(0,1);

while ~isempty(event_queue)
    [ k, v, event_queue ] = simu_popqueue( event_queue );
    if v.type == 0
        [ event_queue, sensor_state, packet_state ] = simu_cycle_tick( k, v, event_queue, sensor_state, packet_state );
    elseif v.type == 1
        [ event_queue, sensor_state, packet_state ] = simu_init_transmit( k, v, event_queue, sensor_state, packet_state );
    elseif v.type == 2
        [ event_queue, sensor_state, packet_state ] = simu_packet_finish( k, v, event_queue, sensor_state, packet_state );
    end
end

end

