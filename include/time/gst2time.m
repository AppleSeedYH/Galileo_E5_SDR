% galileo system time to time -------------------------------------------------
function t = gst2time(week, sec)

gst0=[1999,8,22,0,0,0];
t=epoch2time(gst0);

if (sec<-1E9||1E9<sec) 
    sec=0.0;
end

t=t+86400*7*week+sec;