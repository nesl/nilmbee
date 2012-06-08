function evnt = poisson_event_gen( lambda, timelimit, eventlimit, moteid, filename )
%POISSON_EVENT_GEN Summary of this function goes here
%   Detailed explanation goes here

evnt = zeros(0, 3);
randcount = length(moteid) * min(eventlimit, floor(timelimit * lambda * 1.1) + 100);
randnumbers = exprnd(1/lambda, 1, randcount);
j = 1;
for id = moteid
    time = 0;
    s = 0;
    ecnt = 0;
    while time < timelimit && ecnt < eventlimit
        time = time + randnumbers(j);
        j = j + 1;
        ecnt = ecnt + 1;
        s = 1 - s;
        evnt = [evnt; id  s  time];
    end
end

[b, ix] = sort(evnt(:, 3));
evnt = evnt(ix, :);
evnt(1:end-1, 3) = evnt(2:end, 3) - evnt(1:end-1, 3);
evnt(end, 3) = 2.5;

fid = fopen(filename, 'w');
for i=1:size(evnt,1)
    fprintf(fid, '%d %d %f\n', evnt(i,1), evnt(i,2), evnt(i,3));
end
fclose(fid);

display([num2str(size(evnt,1)) ' events generated. ']);

end
