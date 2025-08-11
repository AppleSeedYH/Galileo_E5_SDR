function [pos, clk, var] = eph2pos(time, eph)
%EPH2POS   Compute satellite position and clock from broadcast ephemeris
%
%   [pos, clk, var] = eph2pos(time, eph)
%
% Inputs:
%   time – struct with fields .time (integer sec) and .sec (fractional sec)
%   eph  – struct with ephemeris fields:
%          .sat, .toe, .toc, .A, .e, .i0, .OMG0, .omg,
%          .deln, .OMGd, .idot, .cus, .cuc, .crs, .crc, .cis, .cic,
%          .f0, .f1, .f2, .sva
%
% Outputs:
%   pos – 3×1 position vector [x; y; z] (m)
%   clk – clock bias (s)
%   var – variance of position/clock error (m^2)

    % Return zeros if invalid semi-major axis
    if eph.A <= 0
        pos = zeros(3,1);
        clk = 0;
        var = 0;
        return;
    end

    % Time from ephemeris epoch
    tk = time - eph.toe;

    % Select gravitational constant and Earth rotation rate
    [sys, prn] = satsys(eph.sat);
    switch sys
        case Const.SYS_GAL
            mu   = Const.MU_GAL;
            omge = Const.OMGE_GAL;
        case Const.SYS_CMP
            mu   = Const.MU_CMP;
            omge = Const.OMGE_CMP;
        otherwise
            mu   = Const.MU_GPS;
            omge = Const.OMGE;
    end

    % Mean anomaly
    M = eph.M0 + (sqrt(mu/(eph.A^3)) + eph.deln) * tk;

    % Solve Kepler's equation for eccentric anomaly E
    E  = M;
    Ek = 0;
    for n = 1:Const.MAX_ITER_KEPLER
        Ek = E;
        E  = E - (E - eph.e*sin(E) - M) / (1 - eph.e*cos(E));
        if abs(E - Ek) < Const.RTOL_KEPLER
            break;
        end
    end
    if abs(E - Ek) >= Const.RTOL_KEPLER
        % iteration failed
        pos = zeros(3,1);
        clk = 0;
        var = 0;
        return;
    end

    sinE = sin(E);
    cosE = cos(E);

    % Argument of latitude, radius, inclination
    u = atan2(sqrt(1 - eph.e^2)*sinE, cosE - eph.e) + eph.omg;
    r = eph.A * (1 - eph.e*cosE);
    i = eph.i0 + eph.idot * tk;

    % Second harmonic corrections
    sin2u = sin(2*u); cos2u = cos(2*u);
    u = u + eph.cus*sin2u + eph.cuc*cos2u;
    r = r + eph.crs*sin2u + eph.crc*cos2u;
    i = i + eph.cis*sin2u + eph.cic*cos2u;

    % Position in orbital plane
    x = r * cos(u);
    y = r * sin(u);
    cosi = cos(i);

    % Compute corrected longitude of ascending node
    if sys == Const.SYS_CMP && (prn <= 5 || prn >= 59)
        % BeiDou GEO
        O = eph.OMG0 + eph.OMGd*tk - omge*eph.toes;
        sinO = sin(O); cosO = cos(O);
        xg = x*cosO - y*cosi*sinO;
        yg = x*sinO + y*cosi*cosO;
        zg = y*sin(i);
        sino = sin(omge*tk); coso = cos(omge*tk);
        COS_5 = cos(5*D2R);
        SIN_5 = sin(5*D2R);
        pos(1) = xg*coso + yg*sino*COS_5 + zg*sino*SIN_5;
        pos(2) = -xg*sino + yg*coso*COS_5 + zg*coso*SIN_5;
        pos(3) = -yg*SIN_5 + zg*COS_5;
    else
        % Other systems
        O = eph.OMG0 + (eph.OMGd - omge)*tk - omge*eph.toes;
        sinO = sin(O); cosO = cos(O);
        pos(1) = x*cosO - y*cosi*sinO;
        pos(2) = x*sinO + y*cosi*cosO;
        pos(3) = y*sin(i);
    end

    % Clock bias
    tkc = time - eph.toc;
    clk = eph.f0 + eph.f1*tkc + eph.f2*tkc^2;

    % Relativity correction
    clk = clk - 2*sqrt(mu*eph.A)*eph.e*sinE / Const.CLIGHT^2;

    % Error variance from URA index
    var = var_uraeph(sys, eph.sva);
end
