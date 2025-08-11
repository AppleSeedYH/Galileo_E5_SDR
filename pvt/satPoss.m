function [rs, dts, var, svh] = satPoss(obs, nav)
%SATPOSS   Compute satellite positions, clocks, and variances
%
%   [rs, dts, var, svh] = satposs(teph, obs, nav, ephopt)
%
% Inputs:
%   teph   – epoch for ephemeris (gtime struct)
%   obs    – 1×n struct array of observations (fields .time, .sat, .P)
%   nav    – navigation data struct
%   ephopt – ephemeris option flag
%
% Outputs:
%   rs  – 6×n matrix; satellite position (m) and velocity (m/s)
%   dts – 2×n matrix; satellite clock bias (s) and drift (s/s)
%   var – 1×n vector; sat position and clock error variances (m^2)
%   svh – 1×n vector; satellite health flags (-1:correction not available)

    %% Constants
    NFREQ      = numel(obs.data(1).P);  % number of frequencies
    %%
    n = obs.n;                      % number of satellites

    % Preallocate outputs
    rs  = zeros(n, 6);
    dts = zeros(n, 2);
    var = zeros(n, 1);
    svh = zeros(n, 1);

    % Loop over observations
    for i = 1:n
        % Find first available pseudorange
        pr = 0;
        for j = 1:NFREQ
            if obs.data(i).P(j) ~= 0
                pr = obs.data(i).P(j);
                break;
            end
        end
        if pr == 0
            % fprintf('no pseudorange %f sat=%2d\n', obs.data(i).time, obs.data(i).sat);
            continue;
        end
        % Estimate transmission time
        time= obs.data(i).time-pr/Const.CLIGHT;
        % ttx = timeadd(obs(i).time, -pr/CLIGHT);
        % Satellite clock bias
        [clk_ok, dt_clk] = ephclk(time, obs.data(i).sat, nav);
        if ~clk_ok
            fprintf('no broadcast clock %f sat=%2d\n', obs.data(i).time, obs(i).sat);
            continue;
        end

        time = time - dt_clk;
        % Satellite position and clock at transmission time
        [pos_ok, rs(i,:), dts(i,:), var(i), svh(i)] = ...
            satpos(time, obs.data(i).sat, nav);
        if ~pos_ok
            % fprintf('no ephemeris %s sat=%2d\n', datestr(ttx), obs(i).sat);
            continue;
        end
        % If clock drift is zero, use broadcast clock
        % if dts(1,i) == 0
        %     [clk_ok2, dt_clk2] = ephclk(ttx, teph, obs(i).sat, nav);
        %     if ~clk_ok2, continue; end
        %     dts(1,i) = dt_clk2;
        %     dts(2,i) = 0;
        %     var(i)   = STD_BRDCCLK^2;
        % end
    end
    % Optional debug trace
    % for i = 1:nmax
    %     fprintf('%s sat=%2d rs=[%10.3f %10.3f %10.3f] dts=%10.3e var=%7.3f svh=%02X\n', ...
    %         datestr(obs(i).time), obs(i).sat, rs(1,i), rs(2,i), rs(3,i), dts(1,i), var(i), svh(i));
    % end
end
