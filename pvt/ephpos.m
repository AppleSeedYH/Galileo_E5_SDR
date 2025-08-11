function [ok, rs, dts, var, svh] = ephpos(time, eph)
%EPHPOS   Satellite position, velocity, clock bias & drift from broadcast ephemeris
%
%   [ok, rs, dts, var, svh] = ephpos(time, teph, sat, iode, nav)
%
% Inputs:
%   time  – gtime struct for desired computation epoch
%   teph  – gtime struct for ephemeris reference epoch
%   sat   – satellite index (integer)
%   iode  – IODE to select ephemeris (-1 for newest)
%   nav   – navigation data struct containing eph entries
%
% Outputs:
%   ok    – logical true if ephemeris was found and solution computed
%   rs    – 6×1 vector: satellite position [x;y;z] (m) and velocity [vx;vy;vz] (m/s)
%   dts   – 2×1 vector: clock bias (s) and clock drift (s/s)
%   var   – variance of pseudorange (m^2)
%   svh   – satellite health flag

    % Initialize outputs
    rs  = zeros(6,1);
    var = 0;
    svh = -1;
    ok  = false;

    % Time offset for velocity approximation (s)
    tt = 1e-3;

    % Compute position and clock at time
    [pos, clk, var] = eph2pos(time, eph);
    rs(1:3) = pos;
    dts(1)  = clk;
    % Compute at time + tt for velocity/drift
    t2 = time + tt;
    [pos2, clk2, ~] = eph2pos(t2, eph);
    rst  = pos2;
    dtst = clk2;
    svh = eph.svh;

    % Compute velocity (m/s) and clock drift (s/s) by numerical derivative
    rs(4:6)   = (rst' - rs(1:3)) / tt;
    dts(2)    = (dtst - dts(1)) / tt;
    
    ok = true;
    %% the following implementation is for all the constellations
    % Determine GNSS system
    % sys = satsys(sat);
    % 
    % switch sys
    %     case {NavSysConstants.SYS_GPS, NavSysConstants.SYS_GAL, ...
    %           NavSysConstants.SYS_QZS, NavSysConstants.SYS_CMP, ...
    %           NavSysConstants.SYS_IRN}
    %         % Select ephemeris
    %         eph = seleph(teph, sat, iode, nav);
    %         if isempty(eph), return; end
    %         % Compute position and clock at time
    %         [pos, clk, var] = eph2pos(time, eph);
    %         rs(1:3) = pos;
    %         dts(1)  = clk;
    %         % Compute at time + tt for velocity/drift
    %         t2 = timeadd(time, tt);
    %         [pos2, clk2, ~] = eph2pos(t2, eph);
    %         rst  = pos2;
    %         dtst = clk2;
    %         svh = eph.svh;
    % 
    %     case NavSysConstants.SYS_GLO
    %         geph = selgeph(teph, sat, iode, nav);
    %         if isempty(geph), return; end
    %         [pos, clk, var] = geph2pos(time, geph);
    %         rs(1:3) = pos;
    %         dts(1)  = clk;
    %         t2 = timeadd(time, tt);
    %         [pos2, clk2, ~] = geph2pos(t2, geph);
    %         rst = pos2;
    %         dtst = clk2;
    %         svh = geph.svh;
    % 
    %     case NavSysConstants.SYS_SBS
    %         seph = selseph(teph, sat, nav);
    %         if isempty(seph), return; end
    %         [pos, clk, var] = seph2pos(time, seph);
    %         rs(1:3) = pos;
    %         dts(1)  = clk;
    %         t2 = timeadd(time, tt);
    %         [pos2, clk2, ~] = seph2pos(t2, seph);
    %         rst = pos2;
    %         dtst = clk2;
    %         svh = seph.svh;
    % 
    %     otherwise
    %         return;
    % end
    % 
    % % Compute velocity (m/s) and clock drift (s/s) by numerical derivative
    % rs(4:6)   = (rst - rs(1:3)) / tt;
    % dts(2)    = (dtst - dts(1)) / tt;
    % 
    % ok = true;
end
