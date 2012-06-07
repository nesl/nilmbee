%%
eventfile = 'event-20min-3.txt';
logfile = 'log/log-event-20min-3-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-4.txt';
logfile = 'log/log-event-20min-4-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-5.txt';
logfile = 'log/log-event-20min-5-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-6.txt';
logfile = 'log/log-event-20min-6-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-7.txt';
logfile = 'log/log-event-20min-7-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-8.txt';
logfile = 'log/log-event-20min-8-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-10.txt';
logfile = 'log/log-event-20min-10-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-12.txt';
logfile = 'log/log-event-20min-12-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-15.txt';
logfile = 'log/log-event-20min-15-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%%
eventfile = 'event-20min-20.txt';
logfile = 'log/log-event-20min-20-simu.txt';
event_q = init_simulator(eventfile, rand(), 0.036);
pkt_state = packet_simulator(event_q);
output_simulator(pkt_state, logfile);

%% %%%%%%%%%%%%%%% Simulation end , Statistics begin %%%%%%%%%%%%
s = zeros(7,0);
s1=s;

eventfile = 'event-20min-3.txt';
logfile = 'log/log-event-20min-3-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-4.txt';
logfile = 'log/log-event-20min-4-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-5.txt';
logfile = 'log/log-event-20min-5-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-6.txt';
logfile = 'log/log-event-20min-6-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-7.txt';
logfile = 'log/log-event-20min-7-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-8.txt';
logfile = 'log/log-event-20min-8-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-10.txt';
logfile = 'log/log-event-20min-10-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-12.txt';
logfile = 'log/log-event-20min-12-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-15.txt';
logfile = 'log/log-event-20min-15-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-20min-20.txt';
logfile = 'log/log-event-20min-20-simu.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%

t = [3 4 5 6 7 8 10 12 15 20];
figure; hold;
plot(t, s(1,:), '--o');
plot(t, s(2,:), '--o');
plot(t, s(3,:), '--o');
plot(t, s(4,:), '--o');
plot(t, s(5,:), '--o');
plot(t, s(6,:), '--o');
plot(t, s(7,:), '-ro', 'LineWidth', 2);
plot(t, s(8,:), '-mo', 'LineWidth', 2);

%%

%t = [0 0.2 0.4];
%figure; hold;
%plot(t, s1(1,:), '--o');
%plot(t, s1(2,:), '--o');
%plot(t, s1(3,:), '--o');
%plot(t, s1(4,:), '-ro', 'LineWidth', 2);
%plot(t, s1(5,:), '-mo', 'LineWidth', 2);
