function [ packet_state ] = packet_simulator_async( event_queue )
%PACKET_SIMULATOR Summary of this function goes here
%   Detailed explanation goes here

sensor_state = cell(1,6);
packet_state = cell(0,1);

while ~isempty(event_queue)
    [ k, v, event_queue ] = simu_popqueue( event_queue );
    if v.type == 3
        [ event_queue, sensor_state, packet_state ] = simu_retransmit_async( k, v, event_queue, sensor_state, packet_state );
    elseif v.type == 1
        [ event_queue, sensor_state, packet_state ] = simu_init_transmit_async( k, v, event_queue, sensor_state, packet_state );
    elseif v.type == 2
        [ event_queue, sensor_state, packet_state ] = simu_packet_finish( k, v, event_queue, sensor_state, packet_state );
    end
end

end

