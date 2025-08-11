%      ch       (I) Receiver channel
%      time     (I) Sampling time of the end of digitized IF data (s)
%      buff     (I) buffer of digitized IF data as complex64 ndarray

function [ch] = chUpdate(ch,time,buffer)

switch ch.status
    case 'SRCH'
        ch = searchSig(ch,time,buffer);
    case 'LOCK'
        ch = trackSig(ch,time,buffer);
    otherwise
        ch.time=time;
end