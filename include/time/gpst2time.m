% galileo system time to time -------------------------------------------------
function t = gpst2time(week, sec)

gpst0=[1980,1,6,0,0,0];
t=epoch2time(gpst0);

if (sec<-1E9||1E9<sec) 
    sec=0.0;
end

t=t+86400*7*week+sec;