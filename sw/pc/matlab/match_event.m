s = zeros(7,0);
s1=s;

eventfile = 'event-5min-3.txt';
logfile = 'log/log-event-5min-3-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-4.txt';
logfile = 'log/log-event-5min-4-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-5.txt';
logfile = 'log/log-event-5min-5-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-6.txt';
logfile = 'log/log-event-5min-6.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-7.txt';
logfile = 'log/log-event-5min-7.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-8.txt';
logfile = 'log/log-event-5min-8-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-10.txt';
logfile = 'log/log-event-5min-10-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-12.txt';
logfile = 'log/log-event-5min-12.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-15.txt';
logfile = 'log/log-event-5min-15-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = 'event-5min-20.txt';
logfile = 'log/log-event-5min-20-alt.txt';
r = match_event_core(eventfile, logfile);
s = [s r(:,3)];

%%
eventfile = '3event-0.0.txt';
logfile = 'log/log-3event.0.0';
r = match_event_core(eventfile, logfile);
s1 = [s1 r(:,3)];

%%
eventfile = '3event-0.2.txt';
logfile = 'log/log-3event.0.2';
r = match_event_core(eventfile, logfile);
s1 = [s1 r(:,3)];

%%
eventfile = '3event-0.4.txt';
logfile = 'log/log-3event.0.4';
r = match_event_core(eventfile, logfile);
s1 = [s1 r(:,3)];

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

t = [0 0.2 0.4];
figure; hold;
plot(t, s1(1,:), '--o');
plot(t, s1(2,:), '--o');
plot(t, s1(3,:), '--o');
plot(t, s1(4,:), '-ro', 'LineWidth', 2);
plot(t, s1(5,:), '-mo', 'LineWidth', 2);
