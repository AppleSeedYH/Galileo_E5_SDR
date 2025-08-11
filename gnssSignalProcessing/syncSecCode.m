function [ch]=syncSecCode(ch,N)

if ch.trk.secSync == 0 && ch.lockCount > 3
    P = dot(real(ch.trk.P(end-N+1:end)), ch.secCode) / N;
    R = mean(abs(real(ch.trk.P(end-N+1:end))));
    if abs(P) >= R * ch.config.THRES_SYNC
        ch.trk.secSync = ch.lockCount;
        ch.trk.secPol = sign(P);
    end
elseif mod(ch.lockCount - ch.trk.secSync, N) == 0
    if abs(mean(real(ch.trk.P(end-N+1:end)))) < ch.config.THRES_LOST
        ch.trk.secSync = 0;
        ch.trk.secPol = 0;
    end
end

if ch.trk.secSync > 0
    if mod(ch.lockCount - ch.trk.secSync , N) ==0 
        C=ch.secCode(4)* ch.trk.secPol;
    else
        C = ch.secCode(mod(ch.lockCount - ch.trk.secSync , N)) * ch.trk.secPol;
    end
    % C = ch.secCode(mod(ch.lockCount - ch.trk.secSync , N)) * ch.trk.secPol;
     % C = ch.secCode(mod(ch.lockCount - ch.trk.secSync , N)+1) * ch.trk.secPol;
    ch.trk.C = ch.trk.C * C;
    ch.trk.P(end) = ch.trk.P(end) * C;
end
