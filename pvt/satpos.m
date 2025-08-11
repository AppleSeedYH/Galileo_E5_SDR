function [ok, rs, dts, var, svh] = satpos(time, sat, nav)
%SATPOS   Compute satellite position, clock, variance, and health based on option
%
%   [ok, rs, dts, var, svh] = satpos(time, teph, sat, ephopt, nav)
%
% Inputs:
%   time   – gtime struct for desired computation epoch
%   teph   – gtime struct for ephemeris reference epoch
%   sat    – satellite index (integer)
%   ephopt – ephemeris option:
%              EPHOPT_BRDC   broadcast ephemeris
%              EPHOPT_SBAS   SBAS ephemeris
%              EPHOPT_SSRAPC SSR absolute corrections
%              EPHOPT_SSRCOM SSR relative corrections
%              EPHOPT_PREC   precise ephemeris
%   nav    – navigation data struct
%
% Outputs:
%   ok     – logical flag (true if solution available)
%   rs     – 3×1 satellite position vector [x; y; z] (m)
%   dts    – 2×1 satellite clock [bias; drift] (s, s/s)
%   var    – variance of pseudorange (m^2)
%   svh    – satellite health flag

    % Initialize outputs
    % rs  = zeros(3,1);
    % dts = zeros(2,1);
    % var = 0;
    % svh = 0;
    % ok  = false;
    
    % now only broadcast ephemeris are implemented
    [ok, rs, dts, var, svh] = ephpos(time, nav.eph(sat));

    if ~ok
        svh = -1;
    end
end
    % switch ephopt
    %     case EPHOPT_BRDC
    %         % Broadcast ephemeris
    %         [ok, rs, dts, var, svh] = ephpos(time, teph, sat, nav, -1);
    % 
    %     case EPHOPT_SBAS
    %         % SBAS ephemeris
    %         [ok, rs, dts, var, svh] = satpos_sbas(time, teph, sat, nav);
    % 
    %     case EPHOPT_SSRAPC
    %         % SSR absolute corrections
    %         [ok, rs, dts, var, svh] = satpos_ssr(time, teph, sat, nav, 0);
    % 
    %     case EPHOPT_SSRCOM
    %         % SSR relative corrections
    %         [ok, rs, dts, var, svh] = satpos_ssr(time, teph, sat, nav, 1);
    % 
    %     case EPHOPT_PREC
    %         % Precise ephemeris
    %         [ok, rs, dts, var] = peph2pos(time, sat, nav, 1);
    %         if ok
    %             svh = 0;
    %         else
    %             svh = -1;
    %         end
    % 
    %     otherwise
    %         % Unsupported option
    %         svh = -1;
    % end