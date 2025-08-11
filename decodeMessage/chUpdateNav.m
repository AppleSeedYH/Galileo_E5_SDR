function pvt = chUpdateNav(pvt, ch)
%SDR_PVT_UDNAV   Update PVT navigation with Galileo I/NAV ephemeris
%
%   pvt = sdr_pvt_udnav(pvt, ch)
%
% Inputs:
%   pvt       – struct with fields
%                 .nav.eph   (1×N struct array of ephemerides)
%                 .rtcm      (RTCM context, modified in-place)
%                 .count     (1×M numeric array)
%                 .rcv.strs  (cell array of receiver strings)
%   ch        – struct with fields
%                 .nav.data  (uint8 array of raw message data)
%                 .nav.type  (numeric message type)
%                 .sat       (string or numeric satellite ID)
%                 .sig       (string, e.g. 'E1B','E5BI')
%                 .time      (timestamp)
%
% Outputs:
%   pvt       – same struct, with eph, rtcm and count updated if applicable

    % extract raw nav data
    data = ch.nav.data;

    % determine system, get satellite number (and PRN, if needed)
    [sys, sat, prn] = satid2no(ch.sat);

    % determine system; skip if none or SBAS
    % sys = satsys(sat, prn);
    if sys == Const.SYS_NONE || sys == Const.SYS_SBS
        return;
    end
    %% read eph, ion, utc information

    % only Galileo I/NAV signals
    if strcmp(ch.sig,'E1B') || strcmp(ch.sig,'E5BI')
        % check for I/NAV page and decode success
        [ok , pvt.nav] = decodeGalInav(data, pvt.nav, sat);
        if ch.nav.type == 4 && ok
            % store satellite ID in the ephemeris slot
            pvt.nav.eph(sat).sat = sat;
        end
    end
end

           
