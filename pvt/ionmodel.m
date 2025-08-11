function delay = ionmodel(t, ion, pos, azel)
%IONMODEL   Compute ionospheric delay using GPS/QZSS broadcast model
%
%   delay = ionmodel(t, ion, pos, azel)
%
% Inputs:
%   t     – gtime struct for epoch
%   ion   – 1×8 ionospheric coefficients [α0...α3 β0...β3]
%           (use nav.ion_gps or nav.ion_qzs)
%   pos   – receiver geodetic [lat; lon; h] (rad, rad, m)
%   azel  – azimuth/elevation [az; el] (rad)
%
% Output:
%   delay – ionospheric delay on L1 in meters

    % Default coefficients (2004/01/01) if none provided
    ion_default = [ ...
        0.1118E-07, -0.7451E-08, -0.5961E-07, 0.1192E-06, ... % α0–α3
        0.1167E+06, -0.2294E+06, -0.1311E+06, 0.1049E+07  ... % β0–β3
    ];
    if any(abs(ion)) == 0
        ion = ion_default;
    end

    % Return zero delay if below horizon or deep underground
    if pos(3) < -1e3 || azel(2) <= 0
        delay = 0;
        return;
    end


    % Earth-centered angle (semi-circle)
    psi = 0.0137 / (azel(2)/pi + 0.11) - 0.022;

    % Subionospheric latitude (semi-circles)
    phi = pos(1)/pi + psi * cos(azel(1));
    phi = max(min(phi, 0.416), -0.416);

    % Subionospheric longitude (semi-circles)
    lam = pos(2)/pi + psi * sin(azel(1)) / cos(phi*pi);

    % Geomagnetic latitude (semi-circles)
    phi = phi + 0.064 * cos((lam - 1.617) * pi);

    % Local time (s)
    [tow, week] = time2gpst(t);
    tt = 43200 * lam + tow;
    tt = tt - floor(tt/86400) * 86400;

    % Slant factor
    f = 1 + 16 * (0.53 - azel(2)/pi)^3;

    % Compute amplitude and period
    amp = ion(1) + phi * (ion(2) + phi * (ion(3) + phi * ion(4)));
    per = ion(5) + phi * (ion(6) + phi * (ion(7) + phi * ion(8)));
    amp = max(amp, 0);
    per = max(per, 72000);

    % Phase argument
    x = 2*pi * (tt - 50400) / per;

    % Ionospheric delay
    if abs(x) < 1.57
        delay = Const.CLIGHT * f * (5e-9 + amp * (1 + x^2 * (-0.5 + x^2/24)));
    else
        delay = Const.CLIGHT * f * 5e-9;
    end
end