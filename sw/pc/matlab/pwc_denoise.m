step = 10;
%y = log_watts(:,2);
%y = channel_7(1:50000,2)/1000;
%y=medfilt1(y, 7);
yrest = [];
s = [1, 0];
for k=1:step:length(y)-step
    [steps yrest] = pwc_online_jp_simple2(yrest, y(k:k+step-1), 0.025, 0);
    if size(steps, 1)>1
        s = [s; steps(1, :)];
        s(end,1) = s(end,1) + s(end-1,1);
        %steps
    end
end

%%
x = zeros(0,1);
for k=2:size(s, 1)
    x(s(k-1,1):s(k,1)) = s(k,2);
end

%%
figure;
plot(y);hold;plot(x,'red');
