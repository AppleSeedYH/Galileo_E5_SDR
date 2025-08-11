function trp = tropmodel(time, pos, azel, humi)
%TROPMODEL   Saastamoinen tropospheric delay model
%
%   trp = tropmodel(time, pos, azel, humi)
%
% Inputs:
%   time – gtime struct (unused in this model but kept for interface)
%   pos  – receiver geodetic [lat; lon; h] (rad, rad, m)
%   azel – azimuth/elevation [az; el] (rad)
%   humi – relative humidity (unitless, e.g., 0.7)
%
% Output:
%   trp  – tropospheric delay (m)

    % Constants
    PI = pi;
    temp0 = 15.0;              % temperature at sea level (°C)

    % Elevation angle must be above horizon
    if pos(3) < -100 || pos(3) > 1e4 || azel(2) <= 0
        trp = 0;
        return;
    end

    % Height above sea level (m)
    hgt = max(pos(3), 0);

    % Standard atmosphere model
    pres = 1013.25 * (1 - 2.2557e-5 * hgt)^5.2568;          % pressure (hPa)
    temp = temp0 - 6.5e-3 * hgt + 273.16;                   % temperature (K)
    e    = 6.108 * humi * exp((17.15 * temp - 4684.0) / (temp - 38.45));  % water vapor pressure (hPa)

    % Zenith angle
    z = PI/2 - azel(2);

    % Hydrostatic delay
    trph = 0.0022768 * pres / ((1 - 0.00266 * cos(2*pos(1)) - 0.00028 * hgt/1e3) * cos(z));
    % Wet delay
    trpw = 0.002277 * (1255/temp + 0.05) * e / cos(z);

    trp = trph + trpw;
end