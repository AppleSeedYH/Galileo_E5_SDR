function [ok, ion, var] = ionocorr(time, nav, sat, pos, azel)
%IONOCORR   Compute ionospheric delay correction
%
%   [ok, ion, var] = ionocorr(time, nav, sat, pos, azel, ionoopt)
%
% Inputs:
%   time    – gtime struct for observation epoch
%   nav     – navigation data struct with fields:
%             .ion_gps (1×8), .ion_qzs (1×8)
%   sat     – satellite index (integer)
%   pos     – receiver geodetic [lat; lon; h] (rad, rad, m)
%   azel    – azimuth/elevation [az; el] (rad)
%   ionoopt – ionosphere option constant:
%             IONOOPT_BRDC, IONOOPT_SBAS, IONOOPT_TEC,
%             IONOOPT_QZS, or IONOOPT_OFF
%
% Outputs:
%   ok   – true if correction computed successfully
%   ion  – ionospheric delay (m)
%   var  – variance of ionospheric delay (m^2)

    % Default
    ok = false;
    ion = 0;
    var = 0;
    sys = satsys(sat);
    
    switch sys
        case Const.SYS_GPS
            ion = ionmodel(time, nav.ion_gps, pos, azel);
            var = (ion * ERR_BRDCI)^2;
            ok = true;
        case Const.SYS_GAL
            ion = ionmodel(time, nav.ion_gal, pos, azel);
            var = (ion * ERR_BRDCI)^2;
            ok = true;
    end
    % switch ionoopt
    %     case IONOOPT_BRDC
    %         % GPS broadcast ionosphere model
    %         ion = ionmodel(time, nav.ion_gps, pos, azel);
    %         var = (ion * ERR_BRDCI)^2;
    %         ok = true;
    % 
    %     case IONOOPT_SBAS
    %         % SBAS ionosphere model
    %         [ok, ion, var] = sbsioncorr(time, nav, pos, azel);
    % 
    %     case IONOOPT_TEC
    %         % IONEX TEC model
    %         [ok, ion, var] = iontec(time, nav, pos, azel, 1);
    % 
    %     case IONOOPT_QZS
    %         % QZSS broadcast ionosphere model (if available)
    %         if norm(nav.ion_qzs) > 0
    %             ion = ionmodel(time, nav.ion_qzs, pos, azel);
    %             var = (ion * ERR_BRDCI)^2;
    %             ok = true;
    %         end
    % 
    %     otherwise
    %         % No correction or unknown option
    %         ion = 0;
    %         if ionoopt == IONOOPT_OFF
    %             var = ERR_ION^2;
    %         else
    %             var = 0;
    %         end
    %         ok = true;
    % end
end
