function [ion, ok] = decodeGalInavIon(data,ion)
%DECODE_GAL_INAV_ION   Decode Galileo I/NAV ionospheric parameters
%
%   [ion, ok] = decode_gal_inav_ion(buff)
%
% Inputs:
%   buff – char array of '0'/'1' bits, length at least 640 (5×128)
%
% Outputs:
%   ion – 1×4 double vector of ionospheric parameters [alpha0, alpha1, alpha2, alpha3]
%   ok  – logical true if successful, false otherwise

    % Initialize
    ok = false;
    ion = zeros(1,4);

    % Constants for scaling
    P2_8  = 2^-8;
    P2_15 = 2^-15;

    try
        % Extract word 5 bits
        word=data{6};
        % Word type field: first 6 bits
        wtype = bin2dec(word(1:6));
        if wtype ~= 5
            return; % not I/NAV word 5
        end
        idx = 6;
        % alpha0: unsigned 11 bits, scale 0.25
        ion(1) = bin2dec(word(idx+1:idx+11))        * 0.25; idx = idx + 11;
        % alpha1: signed 11 bits, scale 2^-8
        ion(2) = twosComp2dec(word(idx+1:idx+11))   * P2_8; idx = idx + 11;
        % alpha2: signed 14 bits, scale 2^-15
        ion(3) = twosComp2dec(word(idx+1:idx+14))   * P2_15; idx = idx + 14;
        % alpha3: unsigned 5 bits
        ion(4) = bin2dec(word(idx+1:idx+5));
        ok = true;
    catch
        % Any error means failure
        ok = false;
        ion = zeros(1,4);
    end
end