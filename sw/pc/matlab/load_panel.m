function [ log_watts ] = load_panel( path )
%LOAD_PANEL Summary of this function goes here
%   Detailed explanation goes here

%log_watts = load([path '/kw.log']);
kwsep = load([path '/kw-sep.log']);
t = load([path '/time.log']);
l = min(length(t), size(kwsep,1));
%log_watts = [t log_watts(:,1)];
%log_watts = [t sum(kwsep(1:l,2:14),2)+kwsep(1:l,16)+sum(kwsep(1:l,18:20),2)];
%log_watts = [t(1:l) kwsep(1:l,4)+kwsep(1:l,10)+kwsep(1:l,12)+kwsep(1:l,13)];
log_watts = [t(1:l) kwsep(1:l,4)+kwsep(1:l,10)+kwsep(1:l,12)+kwsep(1:l,13)+kwsep(1:l,14)];
%log_watts = [t kwsep(1:l,4)+kwsep(1:l,10)+kwsep(1:l,12)];
%log_watts = [t kwsep(1:l,8)];
%log_watts = [t kwsep(1:l,12)];
end

