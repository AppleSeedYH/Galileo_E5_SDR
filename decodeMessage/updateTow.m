function ch = updateTow(ch, tow)
%UPDATE_TOW   Update time-of-week (TOW) in milliseconds modulo one week
%
%   ch = update_tow(ch, sec)
%
% Inputs:
%   ch.sec  – current channel struct with field .tow (ms)  
%   sec     – time offset in seconds
%
% Outputs:
%   ch      – channel struct with updated .tow

    % initialize tow when tow is obtained first time
    if ch.tow < 0
        ch.tow=tow*1000;   % convert tow from s to ms
        ch.tow_v=1;
    elseif ch.tow==tow*1000
        ch.tow_v=1;
    else
        ch.tow=-1;
        ch.tow_v=0;
    end

end
