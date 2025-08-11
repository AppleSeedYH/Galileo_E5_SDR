function pvt = pvtUpdateSol(pvt)
%SDR_PVT_UDSOL   Epoch‐driven PVT update with obs logging and ambiguity resolution
%
%   pvt = sdr_pvt_udsol(pvt, ix)
%
% Inputs:
%   pvt – PVT struct with fields:
%   opt – PVT option struct
%
% Outputs:
%   pvt – updated PVT struct

    % Check if it's time to update the solution
    if pvt.nch~=0
    % if pvt.ix > 0 && (pvt.nch >= pvt.rcv.nch || ...
    %    ix >= pvt.ix + floor(sdr_lag_epoch/SDR_CYC))

        % Resolve millisecond ambiguities for key signals
        % res_obs_amb(pvt.obs, NavSysConstants.SYS_GPS | NavSysConstants.SYS_QZS, ObsCodeConstants.CODE_L5Q, 20e-3);
        % res_obs_amb(pvt.obs, NavSysConstants.SYS_QZS,                     ObsCodeConstants.CODE_L5P, 20e-3);
        % res_obs_amb(pvt.obs, NavSysConstants.SYS_GLO,                     ObsCodeConstants.CODE_L3Q, 10e-3);
        % res_obs_amb(pvt.obs, NavSysConstants.SYS_SBS,                     ObsCodeConstants.CODE_L5Q,  2e-3);

        % Log observation records and emit RTCM3 observation messages
        % out_log_obs(pvt.ix * SDR_CYC, pvt.obs);
        % out_rtcm3_obs(pvt.rtcm, pvt.obs, pvt.rcv.strs{2});

        % Increment valid‐epoch counter
        if pvt.obs.n > 0
            pvt.count(2) = pvt.count(2) + 1;
        end

        % Update the PVT solution
        pvt = updateSol(pvt);

        % Advance epoch time and cycle index
        pvt.time = pvt.time+ Const.SDR_EPOCH;
        pvt.ix   = pvt.ix + floor(Const.SDR_EPOCH/Const.SDR_CYC);

        % Reset per‐epoch counters
        pvt.nch   = 0;
        pvt.obs.n = 0;

        % Adjust epoch index for receiver clock bias if valid
        if pvt.sol.stat
            dtr = floor(pvt.sol.dtr(1)/0.02 + 0.5) * 0.02;
            pvt.ix = pvt.ix + floor(dtr/SDR_CYC);
        end
    end
end
