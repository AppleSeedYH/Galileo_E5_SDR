function [ok,nav] = decodeGalInav(buff, nav, sat)
%DECODE_GAL_INAV   Decode Galileo I/NAV into ephemeris, iono, and UTC
%
%   ok = decode_gal_inav(buff, eph, ion, utc)
%
% Inputs:
%   buff  – vector of uint8 symbols for one INAV page
%   eph   – struct or array of ephemeris entries; pass [] to skip ephemeris decoding
%   ion   – vector for ionospheric parameters; pass [] to skip iono decoding
%   utc   – vector for UTC parameters; pass [] to skip UTC decoding
%
% Output:
%   ok    – logical flag (true if all requested decodings succeeded)

    % Debug trace

    ok = true;
    % Ephemeris decoding
        [nav.eph(sat), ok] = decodeGalInavEph(buff, nav.eph(sat));
        if ~ok
            return;
        end
    % Ionospheric data decoding
        [nav.ion_gal, ok] = decodeGalInavIon(buff, nav.ion_gal);
        if ~ok
            return;
        end
    % UTC data decoding
        % [utc, ok] = decodeGalInavUtc(buff, utc);
        % if ~ok
        %     return;
        % end
end
