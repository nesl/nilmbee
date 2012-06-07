function [ steps, yrest1 ] = pwc_online_jp_simple( yrest, ynew, gamma )
%PWC_ONLINE_JP_SIMPLE Summary of this function goes here
%   Detailed explanation goes here

y = [ yrest; ynew ];
N = length(y);

square = 1;
if (square)
    Eold = 0.5*sum((mean(y)-y).^2);
    steps = [N-1, mean(y)];
else
    Eold = sum(abs(median(y)-y));
    steps = [N-1, median(y)];
end

NLL = zeros(N, 1);
for i = 1:N

    xtest = zeros(N, 1);
    if (square)
        xtest(1:i-1) = mean(y(1:i-1));
        xtest(i:N) = mean(y(i:N));
        NLL(i) = 0.5 * sum((xtest-y).^2);
    else
        xtest(1:i-1) = median(y(1:i-1));
        xtest(i:N) = median(y(i:N));
        NLL(i) = sum(abs(xtest-y));
    end
    
end

[v, i] = min(NLL);
Enew = v + gamma;

if (Enew < Eold)

    steps = zeros(2, 2);
    steps(1, 1) = i-1;
    steps(2, 1) = N;
    if (square)
        steps(1, 2) = mean(y(1:i-1));
        steps(2, 2) = mean(y(i:N));
    else
        steps(1, 2) = median(y(1:i-1));
        steps(2, 2) = median(y(i:N));
    end

    yrest1 = y( i:N );
else
    yrest1 = y;
end

end

