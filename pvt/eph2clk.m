function clk = eph2clk(time, eph)
%EPH2CLK   Compute satellite clock bias from ephemeris parameters
%
%   clk = eph2clk(time, eph)
%
% Inputs:
%   time – struct with fields:
%            .time – integer seconds since epoch
%            .sec  – fractional seconds
%   eph  – ephemeris struct with fields:
%            .toc – clock data reference time (gtime struct)
%            .f0, .f1, .f2 – clock correction coefficients
%
% Output:
%   clk  – satellite clock bias (seconds)

    % Compute time difference t = time - toc
    t = time - eph.toc;
    ts = t;
    % Iterate twice to apply clock model
    for i = 1:2
        t = ts - (eph.f0 + eph.f1 * t + eph.f2 * t^2);
    end
    % Final clock bias
    clk = eph.f0 + eph.f1 * t + eph.f2 * t^2;
end
