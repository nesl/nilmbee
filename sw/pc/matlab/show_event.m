revt_pnt = ans;
t1 = recvevents(revt_pnt).timestamp;
t2 = t1 + 300;
t1 = t1 - 300;

xlim(ax_main, [t1, t2]);
ylim('auto');
ans = revt_pnt+1;

