function config = initConfig()

%% Initialization =========================================================
fprintf('\n  +------------------  Setting configration  ------------------+\n');
config.exit = 0;
config.doProbeData=1;
%% parameters
config.T_ACQ      = 0.010;           % non-coherent integration time for acquisition (s)
config.T_DLL      = 0.010;           % non-coherent integration time for DLL (s)
config.T_CN0      = 1;               % averaging time for C/N0 (s)
config.T_FPULLIN  = 0.5;             % frequency pullin time (s)
config.T_NPULLIN  = 0.7;             % navigation data pullin time (s)
config.N_HIST     = 10000;           % number of P correlator history
config.B_DLL      = 0.25;            % band-width of DLL filter (Hz)
config.B_PLL      = 5.0;             % band-width of PLL filter (Hz)
config.B_FLL      = [5.0, 2.0];      % band-width of FLL filter (Hz) (wide, narrow)
config.SP_CORR    = 0.25;            % default correlator spacing (chip)
config.ADD_CORR   = 0;               % default additional correlator spacing (chip)
config.MAX_DOP    = 5000.0;          % default max Doppler for acquisition (Hz)
config.N_CODE     = 10;              % number of code bank
config.THRES_CN0  = [35.0, 35.0];    % C/N0 threshold (dB-Hz) (lock, lost)
config.THRES_SYNC = 0.02;            % threshold for sec-code sync
config.THRES_SYNC = 0.1;            % threshold for sec-code sync
config.THRES_LOST = 0.002;           % threshold for sec-code lost
config.CYC_SRCH   = 1.0;            % signal search cycle (s)

config.orderDLL   = 1;              % DLL order
config.B_DLL      = 1;            % band-width of DLL filter (Hz)
config.T_CN0      = 0.1;             % averaging time for C/N0 (s)
config.THRES_SYNC = 0.6;            % threshold for sec-code sync
config.THRES_LOST = 0.2;           % threshold for sec-code lost
config.SP_CORR    = 0.5;            % default correlator spacing (chip)
config.THRES_CN0  = [15.0, 15.0];
config.T_DLL      = 0.050; 

%% test for E5b
config.sampleFilePath='D:\LocalCode\Data\CUdataset\L5b_IF20KHz_FS18MHz.bin';
config.IQ=2; % IQ sampling(1: I; 2:+I+Q; 3:+I-Q)
config.interFreq=20e3; % IF frequency of digital IF data in Hz;
config.sampleFreq=18e6;% Sampling frequency of digital IF data in Hz;
config.skipSecond=0; % Number of seconds to be skipped at the beginning of the file
config.sampleBitWidth= 'int8';
% config.navFilePath = '';
config.navFilePath = 'D:\LocalCode\SDRtest\navSave.mat'; % a .mat file storing the .nav struct 

% process options
config.sig='E5BI'; % signal type
config.prn=[2,8,11,12,24,36]; % prns be processed 
config.chNumber=size(config.prn,2); % channel numbers
config.dopMax=5000; % max doppler for searching signals (in Hz)
config.sToProcess= 50;  % (s)