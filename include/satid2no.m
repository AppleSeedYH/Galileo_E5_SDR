function [sys, sat, prn] = satid2no(id)
%SATID2NO   Convert satellite ID string to internal satellite number
%
%   [sat, prn] = satid2no(id)
%
% Inputs:
%   id   – satellite identifier, either
%            • decimal string (e.g. '3', '120') for direct PRN, or
%            • letter + number (e.g. 'G12', 'R05', 'E07')
%
% Outputs:
%   sat  – global satellite number (as returned by satno), or 0 if invalid
%   prn  – parsed PRN (numeric), or [] if invalid
%
%
% And a helper satno(sys, prn) that returns the global sat number.

    % Default outputs
    sat = 0;
    prn = [];

    % Try parsing as plain decimal PRN
    num = str2double(id);
    if ~isnan(num) && num == floor(num)
        prn = floor(num);
        % Determine system by PRN range
        if     Const.MINPRNGPS <= prn && prn <= Const.MAXPRNGPS
            sys = Const.Const.SYS_GPS;
        elseif Const.MINPRNSBS <= prn && prn <= Const.MAXPRNSBS
            sys = Const.Const.SYS_SBS;
        elseif Const.MINPRNQZS <= prn && prn <= Const.MAXPRNQZS
            sys = Const.Const.SYS_QZS;
        else
            return;  % invalid numeric PRN
        end
        sat = satNo(sys, prn);
        return;
    end

    % Otherwise expect Letter+Number, e.g. 'G12'
    tok = regexp(id, '^([A-Za-z])\s*(\d+)$', 'tokens');
    if isempty(tok)
        return;  % invalid format
    end
    code = upper(tok{1}{1});
    prn0 = str2double(tok{1}{2});
    if isnan(prn0)
        return;
    end

    % Map code letter to system and adjust PRN offset
    switch code
        case 'G'  % GPS
            sys = Const.SYS_GPS;
            prn = prn0 + Const.MINPRNGPS - 1;
        case 'R'  % GLONASS
            sys = Const.SYS_GLO;
            prn = prn0 + Const.MINPRNGLO - 1;
        case 'E'  % Galileo
            sys = Const.SYS_GAL;
            prn = prn0 + Const.MINPRNGAL - 1;
        case 'J'  % QZSS
            sys = Const.SYS_QZS;
            prn = prn0 + Const.MINPRNQZS - 1;
        case 'C'  % Beidou/COMPASS
            sys = Const.SYS_CMP;
            prn = prn0 + Const.MINPRNCMP - 1;
        case 'I'  % IRNSS/NavIC
            sys = Const.SYS_IRN;
            prn = prn0 + Const.MINPRNIRN - 1;
        case 'L'  % LEO (SBAS)
            sys = Const.SYS_LEO;
            prn = prn0 + Const.MINPRNLEO - 1;
        case 'S'  % SBAS
            sys = Const.SYS_SBS;
            prn = prn0 + 100;
        otherwise
            return;  % unknown code
    end

    % Final global satellite number
    sat = satNo(sys, prn);
end
