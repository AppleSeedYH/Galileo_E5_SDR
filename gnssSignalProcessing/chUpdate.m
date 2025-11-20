%      ch       (I) Receiver channel
%      time     (I) Sampling time of the end of digitized IF data (s)
%      buff     (I) buffer of digitized IF data as complex64 ndarray
% status: SRCH LOCK IDLE
function [ch] = chUpdate(ch,time,buffer)

switch ch.status
    case 'SRCH'
        ch = searchSig(ch,time,buffer);
    case 'LOCK'
        % LOCK = 'acquisiton" lock
        ch = trackSig(ch,time,buffer);
    otherwise
        ch.time=time;
end