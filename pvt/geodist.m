function [r, e] = geodist(rs, rr)
%GEODIST   Compute geometric distance with Sagnac correction & LOS unit vector
%
%   [r, e] = geodist(rs, rr)
%
% Inputs:
%   rs – 3×1 satellite ECEF position at transmission (m)
%   rr – 3×1 receiver ECEF position at reception (m)
%
% Outputs:
%   r – geometric distance with Sagnac effect (m), negative if error
%   e – 3×1 line-of-sight unit vector from receiver to satellite

    % Check for valid satellite position
    if norm(rs) < Const.RE_WGS84
        r = -1;
        e = zeros(3,1);
        return;
    end

    % Line-of-sight vector (receiver-to-satellite)
    e = rs - rr;
    r0 = norm(e);
    e = e / r0;

    % Add Sagnac correction: OMGE * (x_s*y_r - y_s*x_r) / c
    sagnac = Const.OMGE * (rs(1)*rr(2) - rs(2)*rr(1)) / Const.CLIGHT;
    r = r0 + sagnac;
end
