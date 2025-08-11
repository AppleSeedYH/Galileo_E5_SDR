function pvt = pvtNew(config)
%SDR_PVT_NEW   Allocate and initialize a new PVT structure for a receiver
%
%   pvt = sdr_pvt_new(rcv)
%
% Inputs:
%   rcv   – receiver context struct
%
% Outputs:
%   pvt   – struct with fields initialized for PVT processing

% Constants (ensure these are defined or imported)
% MAXSAT, MAXPRNGLO, FILE_NAV

%% Allocate main PVT struct
pvt = struct();
pvt.time=0;  %epoch time
pvt.ix=0;%epoch cycle (cyc)
pvt.nsat=0; %number of satellites
pvt.nch=0; %updated channels
pvt.count=zeros(3,1); %solution, OBS and NAV count
pvt.rdy = false; % a flag to decide if pvt is ready to computed 
%% Options for pvt
opt = prcopt_default();  % default options for pvt
% opt.navsys = bitor(opt.navsys, Const.SYS_GLO | ...
%                         Const.SYS_GAL | Const.SYS_QZS | ...
%                         Const.SYS_CMP | Const.SYS_IRN);
opt.err(2:3) = 0.03;
opt.ionoopt = Const.IONOOPT_BRDC;
opt.tropopt = Const.TROPOPT_SAAS;
opt.elmin   = Const.EL_MASK * pi/180;
pvt.opt=opt;
%% Observation data
pvt.obs = struct();
NFREQ=5;
NEXOBS=6;
M = NFREQ + NEXOBS;

% template of data
% build a 1×1 template struct matching obsd_t
template = struct( ...
    'time',    double(0), ...
    'sat',     double(0), ...
    'rcv',     double(0), ...
    'SNR',     zeros(1, M), ...
    'LLI',     zeros(1, M), ...
    'code',    zeros(1, M), ...
    'L',       zeros(1, M), ...
    'P',       zeros(1, M), ...
    'D',       zeros(1, M) ...
    );
% Preallocate array of obsd_t structs for MAXSAT satellites
pvt.obs.data = repmat(template, 1, config.chNumber);
pvt.obs.n=0; % count how many observations are there
pvt.obs.nMax=config.chNumber; % count the max number of observations
%% Navigation data
% load local .nav if available
if ~isempty(config.navFilePath)
    temp=load(config.navFilePath);
    pvt.nav=temp.pvt.nav;
else
pvt.nav = struct();

% a struct for ephemeris
template = struct( ...
    'sat',   0, ...           % satellite number
    'iode',  0, ...           % IODE
    'iodc',  0, ...           % IODC
    'sva',   0, ...           % SV accuracy (URA index)
    'svh',   0, ...           % SV health (0=ok)
    'week',  0, ...           % GPS/QZS/GAL week
    'code',  0, ...           % code/data‐source indicator
    'flag',  0, ...           % flag (L2‐P / BDS nav type)
    'toe',   0, ...           % time of ephemeris (seconds)
    'toc',   0, ...           % clock data reference time
    'ttr',   0, ...           % transmission time reference
    'A',     0.0, ...         % semi‐major axis (m^2)
    'e',     0.0, ...         % eccentricity
    'i0',    0.0, ...         % inclination at ref (rad)
    'OMG0',  0.0, ...         % RAAN at weekly epoch (rad)
    'omg',   0.0, ...         % argument of perigee (rad)
    'M0',    0.0, ...         % mean anomaly at ref (rad)
    'deln',  0.0, ...         % mean motion diff (rad/s)
    'OMGd',  0.0, ...         % RAAN rate (rad/s)
    'idot',  0.0, ...         % inclination rate (rad/s)
    'crc',   0.0, ...         % orbit radius cosine corr (m)
    'crs',   0.0, ...         % orbit radius sine corr (m)
    'cuc',   0.0, ...         % arg. of latitude cosine corr (rad)
    'cus',   0.0, ...         % arg. of latitude sine corr (rad)
    'cic',   0.0, ...         % inclination cosine corr (rad)
    'cis',   0.0, ...         % inclination sine corr (rad)
    'toes',  0.0, ...         % toe in week (s)
    'fit',   0.0, ...         % fit interval (h)
    'f0',    0.0, ...         % clock offset (af0)
    'f1',    0.0, ...         % clock drift (af1)
    'f2',    0.0, ...         % clock drift rate (af2)
    'tgd',   zeros(6,1), ...  % group delay parameters
    'Adot',  0.0, ...         % derivative of A (for CNAV)
    'ndot',  0.0 ...          % derivative of mean motion (for CNAV)
    );
pvt.nav.eph = repmat(template, 1, 4*Const.MAXSAT);


pvt.nav.ion_gps=zeros(1,8); % GPS iono model parameters {a0,a1,a2,a3,b0,b1,b2,b3}
pvt.nav.ion_gal=zeros(1,4); % Galileo iono model parameters {ai0,ai1,ai2,0}
pvt.nav.ion_cmp=zeros(1,8); % BeiDou iono model parameters {a0,a1,a2,a3,b0,b1,b2,b3}
end
%% navigation solutions
pvt.sol = struct( ...
    'time', double(0), ...
    'rr',   zeros(6,1), ...
    'qr',   zeros(6,1), ...
    'qv',   zeros(6,1), ...
    'dtr',  zeros(6,1), ...
    'type', double(0), ...
    'stat', double(0), ...
    'ns',   double(0), ...
    'age',  double(0), ...
    'ratio',double(0), ...
    'thres',double(0) ...
    );
%% satellite status
template = struct( ...
    'sys',  uint8(0), ...             % Navigation system identifier
    'vs',   uint8(0), ...             % Single-satellite validity flag
    'azel', zeros(2,1), ...           % Azimuth and elevation angles [az; el] in radians
    'resp', zeros(NFREQ,1), ...       % Pseudorange residuals (meters)
    'resc', zeros(NFREQ,1), ...       % Carrier-phase residuals (meters)
    'vsat', zeros(NFREQ,1,'uint8'), ...   % Per-frequency validity flags
    'snr',  zeros(NFREQ,1,'uint16'), ...  % Signal strength (dB-Hz)
    'fix',  zeros(NFREQ,1,'uint8'), ...   % Ambiguity fix flags (1: fix, 2: float, 3: hold)
    'slip', zeros(NFREQ,1,'uint8'), ...   % Cycle-slip indicators
    'half', zeros(NFREQ,1,'uint8'), ...   % Half-cycle valid flags
    'lock', zeros(NFREQ,1), ...        % Phase lock counters
    'outc', zeros(NFREQ,1,'uint32'), ... % Observation outage counters
    'slipc',zeros(NFREQ,1,'uint32'), ... % Cycle-slip counters
    'rejc', zeros(NFREQ,1,'uint32'), ... % Rejection counters
    'gf',   zeros(NFREQ-1,1), ...     % Geometry-free phase combinations (meters)
    'mw',   zeros(NFREQ-1,1), ...     % Melbourne-Wuebbena linear combinations (meters)
    'phw',  0.0, ...                  % Phase wind-up (cycles)
    'pt',   zeros(2, NFREQ), ...      % Previous carrier-phase timestamps
    'ph',   zeros(2, NFREQ) ...       % Previous carrier-phase observables (cycles)
    );
pvt.sSat = repmat(template, 1, Const.MAXSAT);

% readnav(FILE_NAV, pvt.nav);
end
