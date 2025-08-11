% Update PVT solution by performing point positioning and logging
function pvt = updateSol(pvt)
    % Default processing options
    % opt = prcopt_default();
    % opt.navsys = bitor(opt.navsys, Const.SYS_GLO | ...
    %                     Const.SYS_GAL | Const.SYS_QZS | ...
    %                     Const.SYS_CMP | Const.SYS_IRN);
    % opt.err(2:3) = 0.03;
    % opt.ionoopt = Const.IONOOPT_BRDC;
    % opt.tropopt = Const.TROPOPT_SAAS;
    % opt.elmin   = Const.EL_MASK * pi/180;

    % Current epoch time in seconds since start
    msg = ''; 
    % Point positioning with L1 pseudorange
    [stat, pvt.sol] = pntpos(pvt);
    if stat
        % Correct solution time by receiver clock bias
        % pvt.sol.time = corr_sol_time(pvt.sol.time, pvt.sol.dtr(1));
        
        % Log position solution and NMEA
        % out_log_pos(tsec, pvt.sol, pvt.obs.n);
        % out_nmea(pvt.sol, pvt.ssat, pvt.rcv.strs{1});
        pvt.count(1) = pvt.count(1) + 1;
    else
        pvt.sol.ns = 0;
        % sdr_log(3, sprintf('$LOG,%.3f,PNTPOS ERROR,%s', tsec, msg));
    end
    % pvt.nsat = pvt.obs.n;
end
