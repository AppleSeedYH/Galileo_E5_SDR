function obs = updateObs(time, obs, ch)
%UPDATE_OBS   Update observation data for a given channel
%
%   obs = update_obs(time, obs, ch)
%
% Inputs:
%   time – epoch time (gtime struct or numeric)
%   obs  – observation struct with fields:
%          .data (1×n struct array with fields: time, sat, rcv, code, P, L, D, SNR, LLI)
%          .n    (current number of observations)
%   ch   – channel struct with fields:
%          .sig      – signal identifier string
%          .sat      – satellite ID string
%          .state    – lock state (compare to SDR_STATE_LOCK)
%          .tow      – time-of-week (ms)
%          .nav.fsync – frame-sync flag
%          .trk.sec_sync – secondary code sync flag
%          .adr      – accumulated delta-range (meters)
%          .nav.rev  – navigation bit inversion flag
%          .fd       – Doppler-derived frequency
%          .cn0      – carrier-to-noise ratio (dB-Hz)
%          .lock     – lock counter
%          .T        – measurement interval (s)
%          .trk.err_phas – phase tracking error (cycles)
%
% Output:
%   obs  – updated observation struct

    % Map signal to code number
    code = sig2code(ch.sig);

    % Skip GLONASS FDMA (R+ or R-)
    if contains(ch.sat, 'R+') || contains(ch.sat, 'R-')
        return;
    end

    % Convert satellite string to global PRN index
    [~, sat, ~] = satid2no(ch.sat);
    if sat == 0
        return;
    end

    % Find existing entry for this satellite
    % idx = find([obs.data.sat] == sat, 1);
    % if isempty(idx)
    %     % Append new observation
    %     idx = obs.n + 1;
    %     % initialize new entry
    %     od = struct();
    %     od.time = time;
    %     od.sat  = sat;
    %     od.rcv  = 1;
    % end
    obs.n                = obs.n+1;
    obs.data(obs.n).time = time;
    obs.data(obs.n).sat  = sat;
    obs.data(obs.n).rcv  = 1;

    % Generate pseudorange measurement
    P = genPrng(time, ch);
    j=1; % this can be improved for multi-frequency receiver
    if (P>0.0)
        % Store measurements
        obs.data(obs.n).code(j) = code;
        obs.data(obs.n).P(j)    = P;
        obs.data(obs.n).L(j)    = -ch.adr + (ch.nav.rev ~= 0)*0.5;
        obs.data(obs.n).D(j)    = ch.dopFreq;
        obs.data(obs.n).SNR(j)  = ch.cn0 / Const.SNR_UNIT + 0.5;
        % phase lock indicator
        if ch.lockCount * ch.tCodeCyc <= 2.0 || abs(ch.trk.errPhas) > 0.2
            obs.data(obs.n).LLI(j) = bitor(obs.data(obs.n).LLI(j), 1);
        end
        % half-cycle ambiguity flag
        if ch.nav.fsync <= 0 && ch.trk.secSync <= 0
            obs.data(obs.n).LLI(j) = bitor(obs.data(obs.n).LLI(j), 2);
        end
    end
end