function [ e, states ] = nilm_sensorrecv( pkt, options, states )
%NILM_SENSORRECV Summary of this function goes here
%   Detailed explanation goes here

if ~isfield(states, 'sensor_states')
    states.sensor_states = [];
end

[ e, states.sensor_states ] = parse_event_online(pkt, options.sensors, states.sensor_states);

if ~isempty(e)
    % disable multi-state events
    if e(3)<2 
        states.last_recvevent = e;
    else
        e = zeros(0, 4);
    end
end

end

