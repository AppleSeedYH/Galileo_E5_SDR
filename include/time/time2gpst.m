function [tow, week] = time2gpst(t)
%TIME2GPST   Convert MATLAB gtime struct to GPS time-of-week and week number
%
%   [tow, week] = time2gpst(t)
%
% Inputs:
%   t    – struct with fields:
%           .time  – integer seconds since epoch (e.g., from epoch2time)
%           .sec   – fractional seconds
%
% Outputs:
%   tow  – time-of-week in seconds (fractional)
%   week – GPS week number (integer)

    % Define GPS epoch origin (GPST0) as [1980,1,6,0,0,0]
    gpst0 = [1980,1,6,0,0,0];
    % Convert origin to gtime using epoch2time
    t0 = epoch2time(gpst0);

    % Compute elapsed whole seconds since GPST0
    sec = t - t0;
    % Compute GPS week
    week = floor(sec / (86400*7));
    % Compute time-of-week (remainder seconds + fractional part)
    tow = sec - week * 86400 * 7;
end
