function [stat, sol, azel, ssat, msg] = pntpos(pvt)
%PNTPOS   Point positioning using single-epoch observations
%
%   [stat, sol, azel, ssat, msg] = pntpos(obs, nav, opt)
%
% Inputs:
%   obs – 1×n struct array of observations with fields:
%         .time, .sat, .SNR, .code, .P, etc.
%   nav – navigation data struct
%   opt – processing options struct with fields:
%         .mode, .ionoopt, .tropopt, .sateph, .posopt
%   n   – number of satellites producing measurements
%
% Outputs:
%   stat – solution status (true=success)
%   sol  – solution struct with fields .time, .rr, .dtr, .stat
%   azel – 2×n matrix of azimuth/elevation angles (rad)
%   ssat – MAXSAT×1 struct array of satellite status
%   msg  – status message (char row vector)

    % Initialize outputs
    stat = false;
    obs=pvt.obs;
    nav=pvt.nav;
    opt=pvt.opt;
    sol=pvt.sol;
    n=pvt.obs.n;

    msg = '';
    % n = numel(obs);

    % No data case
    if n <= 0
        msg = 'no observation data';
        sol.stat = 0;
        azel = [];
        ssat = [];
        return;
    end

    % Set solution time and reset status
    sol.time = obs.data(1).time;
    sol.stat = 0;

    % Allocate arrays
    % RS    = zeros(6, n); % position and velocity of satellites
    % dts   = zeros(2, n); % satellite clock bias and drift
    % var   = zeros(1, n); % variance
    % azel_ = zeros(2, n); % azimuth and elevation of satellites 
    % resp  = zeros(1, n);

    % Satellite positions, clocks, and variances
    [satpos, dts, vare, svh] = satPoss(obs, nav);

    % Estimate receiver position with pseudoranges
    [stat, sol] = estpos(obs, satpos, dts, vare, svh, nav, opt, sol);


    % Doppler-based velocity estimation if position succeeded
    % if stat
    %     sol = estvel(obs, RS, dts, nav, opt_, sol, azel_, vsat);
    % end

    % Return azel in requested variable
    % azel = azel_;

    % Populate satellite status array
    % ssat = init_ssat(MAXSAT);
    % for i = 1:MAXSAT
    %     ssat(i).vs = 0;
    %     ssat(i).azel = [0;0];
    %     ssat(i).resp = zeros(1, size(resp,2));
    %     ssat(i).resc = zeros(1, size(resp,2));
    %     ssat(i).snr  = zeros(1, size(resp,2));
    % end
    % for i = 1:n
    %     s = obs(i).sat;
    %     ssat(s).azel = azel_(:, i);
    %     ssat(s).snr(1) = obs(i).SNR(1);
    %     if vsat(i)
    %         ssat(s).vs       = 1;
    %         ssat(s).resp(1)  = resp(i);
    %     end
    % end
end
