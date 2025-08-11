function [ok, trp, var] = tropcorr(time, pos, azel)
%TROPCORR   Compute tropospheric delay correction
%
%   [ok, trp, var] = tropcorr(time, nav, pos, azel, tropopt)
%
% Inputs:
%   time   – gtime struct for epoch
%   nav    – navigation data struct (unused for Saastamoinen/SBAS)
%   pos    – receiver geodetic [lat; lon; h] (rad, rad, m)
%   azel   – azimuth/elevation [az; el] (rad)
%   tropopt – troposphere option constant:
%             TROPOPT_SAAS, TROPOPT_EST, TROPOPT_ESTG, TROPOPT_SBAS, TROPOPT_OFF
%
% Outputs:
%   ok    – true if correction computed
%   trp   – tropospheric delay (m)
%   var   – variance of tropospheric delay (m^2)

    % Default outputs
    ok  = false;
    trp = 0;
    var = 0;
    % Saastamoinen model
    trp = tropmodel(time, pos, azel, Const.REL_HUMI);
    var = (Const.ERR_SAAS / (sin(azel(2)) + 0.1))^2;
    ok = true;

    % switch tropopt
    %     case {TROPOPT_SAAS, TROPOPT_EST, TROPOPT_ESTG}
    %         % Saastamoinen model
    %         % REL_HUMI and ERR_SAAS must be defined in workspace
    %         trp = tropmodel(time, pos, azel, REL_HUMI);
    %         var = (ERR_SAAS / (sin(azel(2)) + 0.1))^2;
    %         ok = true;
    % 
    %     case TROPOPT_SBAS
    %         % SBAS (MOPS) troposphere model
    %         [trp, var] = sbstropcorr(time, pos, azel);
    %         ok = true;
    % 
    %     otherwise
    %         % No correction or off
    %         ok  = true;
    %         trp = 0;
    %         if tropopt == TROPOPT_OFF
    %             var = ERR_TROP^2;
    %         else
    %             var = 0;
    %         end
    % end
end