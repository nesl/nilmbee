function [ steps, yrest1 ] = pwc_online_jp( yrest, ynew, gamma )
%PWC_ONLINE_JP Summary of this function goes here
%   Detailed explanation goes here

y = [ yrest; ynew ];
N = length(y);

r = zeros(0,1);

square = 0;
if (square)
    Eold = 0.5*sum((mean(y)-y).^2);
    steps = [N-1, mean(y)];
else
    Eold = sum(abs(median(y)-y));
    steps = [N-1, median(y)];
end

iter = 1;
maxiter = 10;
while(iter < maxiter)
    
    NLL = zeros(N, 1);
    for i = 1:N
        
        r1 = [r; i];
        r1 = sort(r1);
        r2 = [1; r1; N+1];
        
        xtest = zeros(N, 1);
        for j = 1:iter+1
            l = r2(j):(r2(j+1)-1);
            if (square)
                xtest(l) = mean(y(l));
            else
                xtest(l) = median(y(l));
            end
        end
        
        if (square)
            NLL(i) = 0.5 * sum((xtest-y).^2);
        else
            NLL(i) = sum(abs(xtest-y));
        end
    end
    
    [v, i] = min(NLL);
    Enew = v + gamma * iter;
    
    if (Eold < Enew)
        break;
    end
    
    r = [r; i];
    r = sort(r);
    r2 = [1; r; N+1];

    steps = zeros(iter+1, 2);
    for j = 1:iter+1
        steps(j, 1) = r2(j+1)-1;
        l = r2(j):(r2(j+1)-1);
        if (square)
            steps(j, 2) = mean(y(l));
        else
            steps(j, 2) = median(y(l));
        end
    end
    
    Eold = Enew;
    iter = iter + 1;
end

if (iter > 1)
    yrest1 = y( (steps(iter-1,1)+1):steps(iter,1) );
else
    yrest1 = y;
end

end

