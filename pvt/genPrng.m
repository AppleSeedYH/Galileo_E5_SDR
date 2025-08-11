function P = genPrng(time, ch)
%GEN_PRNG   Generate pseudorange from channel tracking data
%
%   P = gen_prng(time, ch)
%
% Inputs:
%   time – gtime struct or numeric representation
%   ch   – channel struct with fields:
%          .week    – previous GPS week (0 if not set)
%          .tow     – time-of-week in milliseconds
%          .tow_v   – tow validity flag (2 if secondary-code sync)
%          .coff    – code-phase offset (s)
%          .nav.coff– carrier-phase offset (s)
%          .sig     – signal string for debugging
%          .sat     – satellite ID string for debugging
%          .prn     – PRN number for debugging
%          .nav     – navigation struct (used for .coff)
%
% Output:
%   P     – pseudorange (meters)

    % Speed of light constant (m/s)
    CLIGHT = 299792458.0;

    % Convert epoch to GPS seconds-of-week and week number
    [tow, week] = time2gpst(time);
    tau = 0.0;

    if ch.week > 0
        % continuous tracking across week boundaries
        dt_week = (week - ch.week) * 86400.0 * 7;
        tau = dt_week + tow - ch.tow * 1e-3 + ch.codeOffset;

    elseif ch.tow_v == 2
        % resolve 100 ms ambiguity (0.05 <= tau < 0.15)
        tau = tow - ch.tow * 1e-3 + ch.codeOffset + ch.nav.coff;
        tau = tau - floor(tau / 0.1) * 0.1;
        if tau < 0.05
            tau = tau + 0.1;
        end
    end

    % Convert to meters
    P = CLIGHT * tau;
end
