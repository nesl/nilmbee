function [ e ] = get_energy_from_truth( truth )
%GET_ENERGY_FROM_TRUTH Summary of this function goes here
%   Detailed explanation goes here

et = truth(:,5);
d = diff(et);
d(d<0) = 0;
e = sum(d);

end

