function t = epoch2time(ep)
%EPOCH2TIME   Convert calendar date/time to seconds since 1970-01-01
%
%   time = epoch2time(ep)
%
% Inputs:
%   ep — 1×6 vector [year, month, day, hour, minute, second]
%        year in Gregorian calendar (e.g. 2025)
%        second may have fractional part
%
% Output:
%   time — struct with fields:
%            .time  — integer seconds since 1970-01-01 00:00:00 UTC
%            .sec   — fractional part of input seconds (0 ≤ sec < 1)

    % Initialize output
    time = struct('time', 0, 'sec', 0);

    % Days of year at start of each month (non-leap)
    doy = [1,32,60,91,121,152,182,213,244,274,305,335];

    % Extract date components
    year = floor(ep(1));
    mon  = floor(ep(2));
    day  = floor(ep(3));

    % Validate year and month
    if year < 1970 || year > 2099 || mon < 1 || mon > 12
        return;
    end

    % Count days since 1970-01-01
    % leap years every 4 years from 1901–2099
    n_leaps = floor((year - 1969)/4);
    days = (year - 1970) * 365 + n_leaps + doy(mon) + day - 2;
    % add leap-day for current year if past Feb
    if mod(year,4)==0 && mon >= 3
        days = days + 1;
    end

    % Separate integer and fractional seconds
    sec_int = floor(ep(6));
    frac_sec = ep(6) - sec_int;

    % Compute total integer seconds since epoch
    sec_h = floor(ep(4)) * 3600;
    sec_m = floor(ep(5)) * 60;
    time.time = days * 86400 + sec_h + sec_m + sec_int;
    time.sec  = frac_sec;
    t=time.time+time.sec;
end
