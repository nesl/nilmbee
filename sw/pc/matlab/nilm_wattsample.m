function [ step, states ] = nilm_wattsample( sample, options, states )
%NILM_WATTSAMPLE Summary of this function goes here
%   Detailed explanation goes here

if ~isfield(states, 'sample_buf')
    states.sample_buf = zeros(0,size(sample,2));
    states.gamma_buf = zeros(0,1);
    states.timestamp_buf = zeros(0,1);
    states.pwcstates = [];
    states.last_recvevent = [];
    %states.gamma_out = zeros(0,2);
end

step = zeros(0,2);
sample_buf = [states.sample_buf; sample];
gamma_buf = [states.gamma_buf; ones(size(sample,1),1) * 0.0025];
if ~isempty(states.last_recvevent)
    i = abs(sample_buf(:,1)-states.last_recvevent(1))<2.5;
    gamma_buf(i) = 0.0001;
    if ~i(end)
        states.last_recvevent = [];
    end
end
timestamp_buf = [states.timestamp_buf; sample(:,1)];
if size(sample_buf,1) > options.delay
    [steps states.pwcstates] = pwc_online_jp_simple2( ...
            states.pwcstates, sample_buf(1:options.window, 2), ...
            gamma_buf(1:options.window), 0);
    %states.gamma_out = [states.gamma_out; sample_buf(1:options.window,1), gamma_buf(1:options.window)];
    sample_buf = sample_buf(options.window+1:end, :);
    gamma_buf = gamma_buf(options.window+1:end, :);
    if size(steps,1) > 1
        i = steps(1,1);
        step = [timestamp_buf(i+1), steps(1,2)];
        timestamp_buf = timestamp_buf(i+1:end);
    else
        states.end_watts = steps(1,2);
    end
end

states.sample_buf = sample_buf;
states.gamma_buf = gamma_buf;
states.timestamp_buf = timestamp_buf;

end

