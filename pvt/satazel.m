% function [azel, el] = satazel(pos, e)
function [azel] = satazel(geoPos, u_rs)
% AZEL_FROM_UNITVECTOR  Compute satellite azimuth & elevation from a unit ECEF vector 
%
%   [az, el] = azel_from_unitvector([lat; lon; h], u_rs)
%
%   Inputs:
%     lat, lon  – geodetic latitude & longitude (radians)
%     h         – height above ellipsoid (meters) [unused here]
%     u_rs      – 3×1 unit vector from receiver to satellite in ECEF coords
%
%   Outputs:
%     az        – azimuth in radians, measured clockwise from North (0…2π)
%     el        – elevation in radians above horizon (–π/2…+π/2)
%
%   Method:
%     1. Build the ECEF→ENU rotation matrix at (lat, lon).
%     2. Rotate the ECEF LOS vector into local East‐North‐Up.
%     3. az = atan2(East, North), adjusted to [0,2π).
%     4. el = asin(Up).

    % unpack
    lat = geoPos(1);
    lon = geoPos(2);
    % h = geoPos(3);  % not needed for direction

    % ensure column vector
    u = u_rs(:);

    % ECEF→ENU rotation (East; North; Up)
    R = [ -sin(lon),             cos(lon),            0;
          -sin(lat)*cos(lon),  -sin(lat)*sin(lon),   cos(lat);
           cos(lat)*cos(lon),   cos(lat)*sin(lon),   sin(lat) ];

    enu = R * u;

    E = enu(1);
    N = enu(2);
    U = enu(3);

    % Azimuth: from North, clockwise toward East
    azel(1) = atan2(E, N);
    if azel(1) < 0
        azel(1) = azel(1) + 2*pi;
    end

    % Elevation: angle above local horizon
    azel(2) = asin(U);
end

