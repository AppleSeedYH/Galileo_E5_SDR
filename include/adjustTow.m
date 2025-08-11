function ch = adjustTow(ch, sec)
%UPDATE_TOW   Update time-of-week (TOW) in channel struct by a given offset
%
%   ch = update_tow(ch, sec)
%
% Inputs:
%   ch  – channel struct with field .tow (milliseconds), negative if invalid
%   sec – time offset in seconds (can be positive or negative)
%
% Outputs:
%   ch  – updated channel struct with .tow wrapped modulo one week

    % If TOW is invalid, do nothing
    if ch.tow < 0
        return;
    end

    % Convert seconds to milliseconds (integer)
    dt_ms = floor(sec * 1e3);

    % Number of milliseconds in one week
    ms_per_week = 86400 * 7 * 1000;

    % Update and wrap modulo one week
    ch.tow = mod(ch.tow + dt_ms, ms_per_week);
end
