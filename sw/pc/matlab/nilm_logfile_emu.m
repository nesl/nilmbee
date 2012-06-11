path='panel-0607';
%log_watts = load_wattsup('log/log-wattsup.2.txt');
log_watts = load_panel(path);
%log_sensor = load('log/log-sensor.2.txt');
log_sensor = load([path '/log-sensor.txt']);

%log_watts(:,2) = medfilt1(log_watts(:,2), 5);

%%
figure;
%subplot(2,1,1);
hold on;
plot(log_watts(:,1), log_watts(:,2));
ax_main = gca;

options = struct( ...
    'delay', 8, ...
    'window', 2, ...
    'sensors', [2:9 11:19 21 22] ... %[1:3 6 8 11:14 18 19 21 22] ... % 
    );

pnt_w = 1;
pnt_s = 1;
laststep_watts = 0;

states = struct();
recvevents = struct([]);
wattsevents = struct([]);

while pnt_w <= size(log_watts,1) || pnt_s <= size(log_sensor,1)
    if pnt_s > size(log_sensor,1) || (pnt_w <= size(log_watts,1) && log_watts(pnt_w, 1) < log_sensor(pnt_s, 1))
        [step, states] = nilm_wattsample(log_watts(pnt_w, :), options, states);
        pnt_w = pnt_w + 1;
        if ~isempty(step)
            if laststep_watts
                delta_watts = step(2) - laststep_watts;
                wattsevents(end).delta_watts = delta_watts;
                line([wattsevents(end).timestamp wattsevents(end).timestamp], ...
                    [laststep_watts, step(2)], 'color', 'red', 'LineWidth', 2);
            end
            laststep_watts = step(2);
            wattsevents(end+1).timestamp = step(1);
            wattsevents(end).prev_watts = step(2);
            wattsevents(end).delta_watts = 0;
            wattsevents(end).recv_event = [];

            %assoc_event_n = 0;
            wattsid = length(wattsevents);
            for i=1:length(recvevents)
                if abs(step(1)-recvevents(i).timestamp) < min([7 recvevents(i).watts_event(2)])
                    recvevents(i).watts_event = [wattsid abs(step(1)-recvevents(i).timestamp)];
                    % we do one-way (recv->watts) reference for now
                    %wattsevents(wattsid).recv_event(end+1) = i;
                    %assoc_event_n = assoc_event_n + 1;
                end
                if abs(step(1)-recvevents(i).timestamp) < 7
                    recvevents(i).watts_events(end+1,:) = [wattsid abs(step(1)-recvevents(i).timestamp)];
                end
            end
        end
    else
        [event, states] = nilm_sensorrecv(log_sensor(pnt_s, :), options, states);
        pnt_s = pnt_s + 1;
        if ~isempty(event)
            recvevents(end+1).timestamp = event(1);
            recvevents(end).id = event(2);
            recvevents(end).event = event(3);
            recvevents(end).lost_before = event(4);
            recvevents(end).watts_event = [0 1000];
            recvevents(end).watts_events = zeros(0,2);
            i = length(recvevents);
            while i>1 && recvevents(i).timestamp < recvevents(i-1).timestamp
                tmp = recvevents(i);
                recvevents(i) = recvevents(i-1);
                recvevents(i-1) = tmp;
                i = i-1;
            end
            %line([event(1) event(1)], [2, 2+1*(event(3)-0.5)], 'color', 'green');
        end
    end
end

if laststep_watts
    delta_watts = states.end_watts - laststep_watts;
    wattsevents(end).delta_watts = delta_watts;
    line([wattsevents(end).timestamp wattsevents(end).timestamp], ...
        [laststep_watts, states.end_watts], 'color', 'red', 'LineWidth', 2);
end
