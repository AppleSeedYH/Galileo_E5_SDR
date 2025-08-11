function sat = satNo(sys, prn)
%SATNO   Compute unified satellite index from system flag and PRN
%
%   sat = satno(sys, prn)
%
% Inputs:
%   sys  – navigation system flag (use Const class)
%   prn  – satellite PRN or slot number
%
% Output:
%   sat  – unified satellite index (1-based), or 0 if invalid

    % Default invalid
    sat = 0;
    if prn <= 0
        return;
    end

    switch sys
        case Const.SYS_GPS
            % GPS satellites
            if prn < Const.MINPRNGPS || prn > Const.MAXPRNGPS
                return;
            end
            sat = prn - Const.MINPRNGPS + 1;

        case Const.SYS_GLO
            % GLONASS satellites
            if prn < Const.MINPRNGLO || prn > Const.MAXPRNGLO
                return;
            end
            sat = Const.NSATGPS + prn - Const.MINPRNGLO + 1;

        case Const.SYS_GAL
            % Galileo satellites
            if prn < Const.MINPRNGAL || prn > Const.MAXPRNGAL
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + prn - Const.MINPRNGAL + 1;

        case Const.SYS_QZS
            % QZSS satellites
            if prn < Const.MINPRNQZS || prn > Const.MAXPRNQZS
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + Const.NSATGAL + prn - Const.MINPRNQZS + 1;

        case Const.SYS_CMP
            % BeiDou satellites
            if prn < Const.MINPRNCMP || prn > Const.MAXPRNCMP
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + Const.NSATGAL + Const.NSATQZS + prn - Const.MINPRNCMP + 1;

        case Const.SYS_IRN
            % IRNSS satellites
            if prn < Const.MINPRNIRN || prn > Const.MAXPRNIRN
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + Const.NSATGAL + Const.NSATQZS + Const.NSATCMP + prn - Const.MINPRNIRN + 1;

        case Const.SYS_LEO
            % LEO satellites
            if prn < Const.MINPRNLEO || prn > Const.MAXPRNLEO
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + Const.NSATGAL + Const.NSATQZS + Const.NSATCMP + Const.NSATIRN + prn - Const.MINPRNLEO + 1;

        case Const.SYS_SBS
            % SBAS satellites
            if prn < Const.MINPRNSBS || prn > Const.MAXPRNSBS
                return;
            end
            sat = Const.NSATGPS + Const.NSATGLO + Const.NSATGAL + Const.NSATQZS + Const.NSATCMP + Const.NSATIRN + Const.NSATLEO + prn - Const.MINPRNSBS + 1;

        otherwise
            % Unknown system
            return;
    end
end