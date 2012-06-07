function [ log_watts ] = load_wattsup( file )
%LOAD_WATTSUP Summary of this function goes here
%   Detailed explanation goes here

log_watts = load(file);
log_watts(:,2) = log_watts(:,2) / 10000;
log_watts = log_watts(:,1:2);

end

