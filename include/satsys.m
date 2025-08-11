function [sys, prn] = satsys(sat)
%SATSYS   Convert unified satellite index to GNSS system and PRN
%
%   [sys, prn] = satsys(sat)
%
% Inputs:
%   sat  – satellite index (1–MAXSAT), or ≤0 for invalid
%
% Outputs:
%   sys  – system flag (Const.SYS_*)
%   prn  – satellite PRN/slot number, or 0 if invalid
%
% Example:
%   [sys, prn] = satsys(42);
%   % sys might be Const.SYS_GAL, prn the Galileo PRN

    % Initialize
    sys = Const.SYS_NONE;
    prn = 0;

    % Total counts per system
    nGPS = Const.NSATGPS;
    nGLO = Const.NSATGLO;
    nGAL = Const.NSATGAL;
    nQZS = Const.NSATQZS;
    nCMP = Const.NSATCMP;
    % nIRN = Const.NSATIRN;
    % nLEO = Const.NSATLEO;
    % nSBS = Const.NSATSBS;  % if defined, else use Const.NSYSSBS

    % Validate index
    % if sat <= 0 || sat > (nGPS + nGLO + nGAL + nQZS + nCMP + nIRN + nLEO + nSBS)
    if sat <= 0 || sat > (nGPS + nGLO + nGAL + nQZS + nCMP)
        return;
    end

    % GPS
    if sat <= nGPS
        sys = Const.SYS_GPS;
        prn = sat + Const.MINPRNGPS - 1;
        return;
    end

    % GLONASS
    sat = sat - nGPS;
    if sat <= nGLO
        sys = Const.SYS_GLO;
        prn = sat + Const.MINPRNGLO - 1;
        return;
    end

    % Galileo
    sat = sat - nGLO;
    if sat <= nGAL
        sys = Const.SYS_GAL;
        prn = sat + Const.MINPRNGAL - 1;
        return;
    end

    % QZSS
    sat = sat - nGAL;
    if sat <= nQZS
        sys = Const.SYS_QZS;
        prn = sat + Const.MINPRNQZS - 1;
        return;
    end

    % BeiDou
    sat = sat - nQZS;
    if sat <= nCMP
        sys = Const.SYS_CMP;
        prn = sat + Const.MINPRNCMP - 1;
        return;
    end

    % IRNSS
    % sat = sat - nCMP;
    % if sat <= nIRN
    %     sys = Const.SYS_IRN;
    %     prn = sat + Const.MINPRNIRN - 1;
    %     return;
    % end

    % LEO
    % sat = sat - nIRN;
    % if sat <= nLEO
    %     sys = Const.SYS_LEO;
    %     prn = sat + Const.MINPRNLEO - 1;
    %     return;
    % end
    % 
    % % SBAS
    % sat = sat - nLEO;
    % if sat <= nSBS
    %     sys = Const.SYS_SBS;
    %     prn = sat + Const.MINPRNSBS - 1;
    %     return;
    % end
end
