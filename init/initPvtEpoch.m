function pvt = initPvtEpoch(pvt, ix, ch)
%INIT_EPOCH   Initialize PVT epoch time and index based on channel data
%
%   pvt = init_epoch(pvt, ix, ch)
%
% Inputs:
%   pvt – struct with fields:
%          .time  – current epoch time (to be set)
%          .ix    – current epoch index (to be set)
%   ix  – channel-specific index value (integer)
%   ch  – channel struct with fields:
%          .week – GPS week number (0 if invalid)
%          .tow  – time-of-week in milliseconds
%
% Outputs:
%   pvt – updated struct with .time and .ix set when ch.week > 0

    % If week is zero, do not initialize
    if ch.week == 0
        return;
    end
    sdr_epoch=Const.SDR_EPOCH;
    % Convert TOW from milliseconds to seconds
    tow_s = ch.tow * 1e-3;
    % Align to the next epoch boundary at multiples of sdr_epoch
    
    tow_epoch = floor(tow_s / sdr_epoch) * sdr_epoch + sdr_epoch;

    % Compute PVT epoch time as GPS week + time-of-week
    pvt.time = gpst2time(ch.week, tow_epoch);

    % Compute epoch index offset with a small timing correction of 0.07s
    pvt.ix = ix + floor((tow_epoch - tow_s - 0.07) / Const.SDR_CYC + 0.5);  % emulate ROUND macro

    % Round the index to a multiple of 20 ms for consistency
    pvt.ix = floor(pvt.ix / 20) * 20;
end