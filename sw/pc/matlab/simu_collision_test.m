function [ packet_state ] = simu_collision_test( time, packet_state )
%SIMU_COLLISION_TEST Summary of this function goes here
%   Detailed explanation goes here

for i=length(packet_state)-1:-1:1
    if ~packet_state{i}.finished
        packet_state{i}.dirty = 1;
        packet_state{end}.dirty = 1;
    %elseif time - packet_state{i}.finished < 0.01
    %    packet_state{end}.dirty = (rand()*(time - packet_state{i}.finished) < 0.002);
    else
        break;
    end
end

end

