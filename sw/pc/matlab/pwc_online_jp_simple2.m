function [ steps, yrest1 ] = pwc_online_jp_simple2( yrest, ynew, gamma, delay )
%PWC_ONLINE_JP_SIMPLE Summary of this function goes here
%   Detailed explanation goes here

if isempty(yrest)
    yrest = zeros(0, 5);
end

if length(gamma) == 1
    gamma = ones(length(ynew),1) * gamma;
end

s1new = sum(ynew);
s2new = sum(ynew.^2);

y = [yrest ; ynew zeros(length(ynew), 3) gamma ];
Nold = size(yrest, 1);
Ndelta = length(ynew);
Nnew = Nold + Ndelta;

Eold = 0.5*sum((y(:,1)-mean(y(:,1))).^2);
steps = [Nnew-1, mean(y(:,1))];

NLL = zeros(Nnew, 1);
y(1:Nold, 3) = y(1:Nold, 3) + s2new;
y(1:Nold, 4) = y(1:Nold, 4) + s1new;
NLL(1:Nold) = ( y(1:Nold, 2) + y(1:Nold, 3) ...
        - y(1:Nold,4).*y(1:Nold,4)./(Nnew:-1:Nnew-Nold+1)' ) * 0.5 ...
        + y(1:Nold,5);

s1 = sum(yrest(:,1));
s2 = sum(yrest(:,1).^2);
for i = Nold+1:Nnew
    y(i,2) = s2 - s1*s1/(i-1);
    s1 = s1 + y(i,1);
    s2 = s2 + y(i,1) * y(i,1);
    y(i,3) = sum(y(i:Nnew,1).^2);
    y(i,4) = sum(y(i:Nnew,1));
    
    NLL(i) = 0.5*( y(i, 2) + y(i, 3) - y(i,4) * y(i,4) / (Nnew-i+1) ) + y(i,5);
end

[v, i] = min(NLL);
Enew = v;

if (Enew < Eold && Nnew-i > delay)

    steps = zeros(2, 2);
    steps(1, 1) = i-1;
    steps(2, 1) = Nnew;
    steps(1, 2) = median(y(1:i-1));
    steps(2, 2) = median(y(i:Nnew));

    yrest1 = y( i:Nnew , : );
else
    yrest1 = y;
end

end

