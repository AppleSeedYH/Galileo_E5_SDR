function sat = satId(sig, prn)
%SDR_SAT_ID   Generate satellite identifier string from signal and PRN
%
%   sat = sdr_sat_id(sig, prn)
%
% Inputs:
%   sig  – signal string (e.g. 'L1CA', 'G1CA', 'E5BI', 'B1I', 'I1SD')
%   prn  – numeric PRN or slot number (integer)
%
% Output:
%   sat  – two‐ or three‐character satellite ID (char array)

    % Default unknown
    sat = '??';

    if startsWith(sig, 'L')   % GPS, SBAS, or QZSS signals
        if prn >= 1 && prn <= 63
            % GPS
            sat = sprintf('G%02d', prn);
        elseif prn >= 120 && prn <= 158
            % SBAS (offset PRN by 100)
            sat = sprintf('S%02d', prn - 100);
        else
            % QZSS: delegate to qzss helper (implement separately)
            sat = sat_id_qzss(sig, prn);
        end

    elseif any(strcmp(sig, {'G1CA', 'G2CA'}))
        % GLONASS FDMA: sign indicates frequency channel
        if prn < 0
            sat = sprintf('R-%d', -prn);
        else
            sat = sprintf('R+%d', prn);
        end

    elseif startsWith(sig, 'G')
        % GLONASS CDMA: PRN value 1–27
        sat = sprintf('R%02d', prn);

    elseif startsWith(sig, 'E')
        % Galileo
        sat = sprintf('E%02d', prn);

    elseif startsWith(sig, 'B')
        % BeiDou / COMPASS
        sat = sprintf('C%02d', prn);

    elseif startsWith(sig, 'I')
        % NavIC/IRNSS
        sat = sprintf('I%02d', prn);
    
    else
        % Unknown system
        sat = '???';
    end
end
