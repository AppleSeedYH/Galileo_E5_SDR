function var = var_uraeph(sys, ura)
%VAR_URAEPH   Compute position error variance from URA or SISA index
%
%   var = var_uraeph(sys, ura)
%
% Inputs:
%   sys – navigation system flag (NavSysConstants.SYS_*)
%   ura – URA index (0–14 for GPS, up to 255 for Galileo)
%
% Output:
%   var – variance of ephemeris error (m^2)

    % GPS URA table (indices 0–14)
    ura_value = [ ...
        2.4, 3.4, 4.85, 6.85, 9.65, 13.65, 24.0, 48.0, ...
        96.0, 192.0, 384.0, 768.0, 1536.0, 3072.0, 6144.0
    ];

    if sys == Const.SYS_GAL
        % Galileo SISA per ref [7] section 5.1.11
        if ura <= 49
            sigma = ura * 0.01;
        elseif ura <= 74
            sigma = 0.5 + (ura - 50) * 0.02;
        elseif ura <= 99
            sigma = 1.0 + (ura - 75) * 0.04;
        elseif ura <= 125
            sigma = 2.0 + (ura - 100) * 0.16;
        else
            % Default NAPA assumption
            sigma = 500; % error of galileo ephemeris for NAPA (m) 
        end
        var = sigma^2;
    else
        % GPS URA per ref [1] section 20.3.3.3.1.1
        if ura < 0 || ura > 14
            sigma = ura_value(end);
        else
            sigma = ura_value(ura+1);
        end
        var = sigma^2;
    end
end
