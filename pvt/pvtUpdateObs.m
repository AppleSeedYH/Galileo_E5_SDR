function pvt = pvtUpdateObs(pvt, ix, ch)
%UPDATE_OBS_LOGIC   Initialize epoch and update observation count
%
%   pvt = update_obs_logic(pvt, ix, ch)
%
% Inputs:
%   pvt – struct with fields:
%          .ix    – received IF data cycle (cyc)
%          .time  – current epoch time
%          .obs   – observation data struct
%          .nch   – channel count
%   ix  – received IF data cycle (cyc)
%   ch  – channel struct with fields:
%          .state     – receiver lock state
%          .tow       – time of week (ms)
%          .tow_v     – time-of-week validity flag
%          .nav.fsync – frame sync flag
%          .trk.sec_sync – secondary code sync flag
%
% Outputs:
%   pvt – updated struct, with possible epoch initialization and obs update

    % If this is the first update (or ix reset), initialize epoch
    if pvt.ix <= 0
        pvt = initPvtEpoch(pvt, ix, ch);
    end

    % If this channel's ix matches PVT epoch index, update observations
    if ix == pvt.ix
        % Only update when locked, TOW valid, and either frame or sec sync
        if  ch.tow >= 0 && ch.tow_v > 0 && ...
           (ch.nav.fsync > 0 || ch.trk.secSync > 0)
           %  if ch.state == SDR_STATE_LOCK && ch.tow >= 0 && ch.tow_v > 0 && ...
           % (ch.nav.fsync > 0 || ch.trk.sec_sync > 0)

            % update_obs is assumed to modify pvt.obs in place
            pvt.obs = updateObs(pvt.time, pvt.obs, ch);
        end
        % increment channel count for this epoch
        pvt.nch = pvt.nch + 1;
    end
end
