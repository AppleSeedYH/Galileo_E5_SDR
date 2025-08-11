function [utc, ok] = decodeGalInavUtc(data,utc)
%DECODE_GAL_INAV_UTC   Decode Galileo I/NAV UTC parameters
%
%   [utc, ok] = decode_gal_inav_utc(buff)
%
% Inputs:
%   buff – char array of '0'/'1' bits, length at least 6*128
%
% Outputs:
%   utc – 1×8 double vector of UTC parameters [A0, A1, tot, WNt, dt_LS, WN_LSF, DN, dt_LSF]
%   ok  – logical true if successful, false otherwise

    % Initialize
    ok = false;
    utc = zeros(1,8);

    % Constants for scaling
    P2_30 = 2^-30;
    P2_50 = 2^-50;

    try
        % Extract 128-bit word 6
        word=data{7};
        % word type (bits 1-6)
        wtype = bin2dec(word(1:6));
        if wtype ~= 6
            return;
        end
        idx = 6;
        % A0: signed 32 bits, scale 2^-30
        utc(1) = twosComp2dec(word(idx+1:idx+32)) * P2_30; idx = idx + 32;
        % A1: signed 24 bits, scale 2^-50
        utc(2) = twosComp2dec(word(idx+1:idx+24)) * P2_50; idx = idx + 24;
        % dt_LS: unsigned 8 bits
        utc(5) = bin2dec(word(idx+1:idx+8)); idx = idx + 8;
        % tot: unsigned 8 bits, scale to seconds
        utc(3) = bin2dec(word(idx+1:idx+8)) * 3600.0; idx = idx + 8;
        % WNt: unsigned 8 bits
        utc(4) = bin2dec(word(idx+1:idx+8)); idx = idx + 8;
        % WN_LSF: unsigned 8 bits
        utc(6) = bin2dec(word(idx+1:idx+8)); idx = idx + 8;
        % DN: unsigned 3 bits
        utc(7) = bin2dec(word(idx+1:idx+3)); idx = idx + 3;
        % dt_LSF: signed 8 bits
        utc(8) = twosComp2dec(word(idx+1:idx+8));
        ok = true;
    catch
        ok = false;
        utc = zeros(1,8);
    end
end
