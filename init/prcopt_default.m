function opt = prcopt_default()
%PRCOPTT_DEFAULT   Default processing options struct
%
%   opt = prcopt_default()
%
% Returns a struct with fields matching prcopt_t and initialized to C defaults.

    % Positioning mode constants assumed defined in NavSysConstants or similar
    opt.mode       = Const.PMODE_SINGLE;             % positioning mode
    opt.soltype    = 0;                        % solution type: forward
    opt.nf         = 2;                        % number of frequencies
    opt.navsys     = Const.SYS_GPS;  % navigation systems
    opt.elmin      = 15.0 * pi/180;            % elevation mask angle (rad)
    opt.snrmask    = struct('mask',zeros(1,2));% SNR mask placeholder
    opt.sateph     = Const.EPHOPT_BRDC;               % satellite ephemeris option
    opt.modear     = 1;                        % ambiguity resolution mode
    opt.glomodear  = 1;                        % GLONASS AR mode
    opt.bdsmodear  = 1;                        % BeiDou AR mode
    opt.maxout     = 5;                        % outage reset count
    opt.minlock    = 0;                        % min lock for ambiguity
    opt.minfix     = 10;                       % min fixes to hold
    opt.armaxiter  = 1;                        % AR max iteration
    opt.ionoopt    = Const.IONOOPT_BRDC;       % ionosphere correction: broadcast model
    opt.tropopt    = Const.TROPOPT_SAAS;       % troposphere correction: Saastamoinen model 
    opt.dynamics   = 0;                        % no dynamics model
    opt.tidecorr   = 0;                        % tide correction off
    opt.niter      = 1;                        % filter iterations
    opt.codesmooth = 0;                        % no code smoothing
    opt.intpref    = 0;                        % no interpolation reference
    opt.sbascorr   = 0;                        % SBAS corrections off
    opt.sbassatsel = 0;                        % all SBAS sats
    opt.rovpos     = 0;                        % rover pos from prcopt
    opt.refpos     = 0;                        % base pos from prcopt
    opt.eratio     = [100, 100];               % code/phase error ratio
    opt.err        = [100.0, 0.003, 0.003, 0.0, 1.0]; % measurement error factors
    opt.std        = [30.0, 0.03, 0.3];         % initial state std
    opt.prn        = [1e-4, 1e-3, 1e-4, 1e-1, 1e-2, 0.0]; % process noise std
    opt.sclkstab   = 5e-12;                    % satellite clock stability
    opt.thresar    = [3.0, 0.9999, 0.25, 0.1, 0.05, 0, 0, 0]; % AR thresholds
    opt.elmaskar   = 0.0;                      % AR elevation mask (deg)
    opt.elmaskhold = 0.0;                      % hold elevation mask (deg)
    opt.thresslip  = 0.05;                     % slip threshold (m)
    opt.maxtdiff   = 30.0;                     % max time diff (s)
    opt.maxinno    = 30.0;                     % max innovation (m)
    opt.maxgdop    = 30.0;                     % max GDOP
    opt.baseline   = [0, 0];                   % baseline constraint
    opt.ru         = [0, 0, 0];                % rover ECEF pos
    opt.rb         = [0, 0, 0];                % base ECEF pos
    opt.anttype    = {'',''};                  % antenna types
    opt.antdelt    = zeros(2,3);               % antenna deltas
    opt.pcvr       = repmat(struct(),1,2);     % PCV structs placeholder
    opt.exsats     = zeros(1,Const.MAXSAT);    % excluded sats
    opt.maxaveep   = 0;                        % max averaging epochs
    opt.initrst    = 0;                        % init by restart
    opt.outsingle  = 0;                        % output single by outage
    opt.rnxopt     = {'',''};                  % RINEX options
    opt.posopt     = zeros(1,6);               % positioning options
    opt.syncsol    = 0;                        % sync solution disabled
    opt.odisp      = zeros(2,6*11);            % ocean tide loading params
    opt.freqopt    = 0;                        % disable L2-AR
    opt.pppopt     = '';                       % PPP options
end
