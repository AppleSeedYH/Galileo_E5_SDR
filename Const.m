classdef Const
    %SDRCONST   SDR C‐constants for PRN ranges & counts
    
    properties (Constant)
        % GPS
        MINPRNGPS = 1;
        MAXPRNGPS = 32;
        NSATGPS   = Const.MAXPRNGPS - Const.MINPRNGPS + 1;
        NSYSGPS   = 1;
        
        % GLONASS (enable by setting ENAGLO = true below)
        MINPRNGLO = 1;
        MAXPRNGLO = 27;
        NSATGLO   = Const.MAXPRNGLO - Const.MINPRNGLO + 1;
        NSYSGLO   = 1;
        
        % Galileo (enable by setting ENAGAL = true)
        MINPRNGAL = 1;
        MAXPRNGAL = 36;
        NSATGAL   = Const.MAXPRNGAL - Const.MINPRNGAL + 1;
        NSYSGAL   = 1;
        
        % QZSS (enable by setting ENAQZS = true)
        MINPRNQZS   = 193;
        MAXPRNQZS   = 202;
        MINPRNQZS_S = 183;
        MAXPRNQZS_S = 191;
        NSATQZS     = Const.MAXPRNQZS - Const.MINPRNQZS + 1;
        NSYSQZS     = 1;
        
        % BeiDou/COMPASS (enable by setting ENACMP = true)
        MINPRNCMP = 1;
        MAXPRNCMP = 63;
        NSATCMP   = Const.MAXPRNCMP - Const.MINPRNCMP + 1;
        NSYSCMP   = 1;

        % Max Prn
        MAXSAT    = Const.NSATGPS+Const.NSATGLO+Const.NSATGAL+Const.NSATQZS+Const.NSATCMP;
        
        % Satellite system
        SYS_NONE  = 0;
        SYS_GPS   = 1;
        SYS_SBS   = 2;
        SYS_GLO   = 3;
        SYS_GAL   = 4;
        SYS_QZS   = 5;
        SYS_CMP   = 6;

        galPi=3.1415926535898; % the value of pi given by Galileo ICD

        SDR_EPOCH   = 1.0;      % epoch time interval (s)
        LAG_EPOCH   = 0.05;     % max PVT epoch lag (s)
        EL_MASK     = 10.0;     % elavation mask (deg)

        SDR_CYC     = 1e-3;     % IF data processing cycle (s)
        SNR_UNIT    = 0.001;    % SNR unit (dBHz)

        CLIGHT     = 299792458.0;      % speed of light (m/s)

        RE_GLO  = 6378136.0;        % radius of earth (m)
        MU_GPS  = 3.9860050E14;     % gravitational constant
        MU_GLO  = 3.9860044E14;     % gravitational constant
        MU_GAL  = 3.986004418E14;   % earth gravitational constant
        MU_CMP  = 3.986004418E14;   % earth gravitational constant
        J2_GLO  = 1.0826257E-3;     % 2nd zonal harmonic of geopot

        OMGE_GLO = 7.292115e-5;      % earth angular velocity for GLONASS (rad/s)
        OMGE_GAL = 7.2921151467e-5;  % earth angular velocity for Galileo (rad/s)
        OMGE_CMP = 7.292115e-5;      % earth angular velocity for BeiDou/COMPASS (rad/s)

        ERREPH_GLO      = 5.0;               % error of GLONASS ephemeris (m)
        TSTEP           = 60.0;              % integration step for GLONASS ephemeris (s)
        RTOL_KEPLER     = 1e-13;             % relative tolerance for Kepler's equation (unitless)
        DEFURASSR       = 0.15;              % default accuracy of SSR corrections (m)
        MAXECORSSR      = 10.0;              % max SSR orbit correction (m)
        MAXCCORSSR      = 1e-6 * 299792458.0; % max SSR clock correction (m)
        MAXAGESSR       = 90.0;              % max age of SSR orbit/clock data (s)
        MAXAGESSR_HRCLK = 10.0;              % max age of SSR high-rate clock data (s)
        STD_BRDCCLK     = 30.0;              % std dev of broadcast clock error (m)
        STD_GAL_NAPA    = 500.0;             % error of Galileo NAPA ephemeris (m)
        MAX_ITER_KEPLER = 30;                % max iterations for Kepler solver

        MAXITR          = 10;                % max number of iteration for point pos

        OMGE     = 7.2921151467e-5;     % Earth angular velocity (IS-GPS) (rad/s)
        RE_WGS84 = 6378137.0;           % Earth semimajor axis (WGS-84) (m)
        FE_WGS84 = 1.0/298.257223563;   % Earth flattening factor (WGS-84)

        ERR_ION   = 5.0;            % ionospheric delay standard deviation (m)
        ERR_TROP  = 3.0;            % tropospheric delay standard deviation (m)
        ERR_SAAS  = 0.3;            % Saastamoinen model error standard deviation (m)
        ERR_BRDCI = 0.5;            % broadcast ionosphere model error factor (unitless)
        ERR_CBIAS = 0.3;            % code bias error standard deviation (m)
        REL_HUMI  = 0.7;            % relative humidity for Saastamoinen model (unitless)
        MIN_EL    = 5.0 * pi/180;   % minimum elevation for measurement error (rad)

        PMODE_SINGLE        = 0;  % positioning mode: single
        PMODE_DGPS          = 1;  % positioning mode: DGPS/DGNSS
        PMODE_KINEMA        = 2;  % positioning mode: kinematic
        PMODE_STATIC        = 3;  % positioning mode: static
        PMODE_MOVEB         = 4;  % positioning mode: moving-base
        PMODE_FIXED         = 5;  % positioning mode: fixed
        PMODE_PPP_KINEMA    = 6;  % positioning mode: PPP-kinematic
        PMODE_PPP_STATIC    = 7;  % positioning mode: PPP-static
        PMODE_PPP_FIXED     = 8;  % positioning mode: PPP-fixed

        EPHOPT_BRDC   = 0;  % broadcast ephemeris
        EPHOPT_PREC   = 1;  % precise ephemeris
        EPHOPT_SBAS   = 2;  % SBAS (WAAS/EGNOS) ephemeris
        EPHOPT_SSRAPC = 3;  % SSR absolute corrections
        EPHOPT_SSRCOM = 4;  % SSR relative corrections

        IONOOPT_OFF  = 0;  % ionosphere option: correction off
        IONOOPT_BRDC = 1;  % ionosphere option: broadcast model
        IONOOPT_SBAS = 2;  % ionosphere option: SBAS model
        IONOOPT_IFLC = 3;  % ionosphere option: L1/L2 iono-free LC
        IONOOPT_EST  = 4;  % ionosphere option: estimation
        IONOOPT_TEC  = 5;  % ionosphere option: IONEX TEC model
        IONOOPT_QZS  = 6;  % ionosphere option: QZSS broadcast model
        IONOOPT_STEC = 8;  % ionosphere option: SLANT TEC model

        TROPOPT_OFF  = 0;  % troposphere option: correction off
        TROPOPT_SAAS = 1;  % troposphere option: Saastamoinen model
        TROPOPT_SBAS = 2;  % troposphere option: SBAS model
        TROPOPT_EST  = 3;  % troposphere option: ZTD estimation
        TROPOPT_ESTG = 4;  % troposphere option: ZTD+grad estimation
        TROPOPT_ZTD  = 5;  % troposphere option: ZTD correction

        NX    = 4;                   % number of unknowns: X,Y,Z + clock (no offsets yet)
    end
    
    properties (Constant, Access = private)
        % Flags to mimic the C compile-time "#ifdef"s
        ENAGLO = true;
        ENAGAL = true;
        ENAQZS = true;
        ENACMP = true;
    end
    
   properties (Constant)
        CODE_NONE = 0;   % obs code: none or unknown
        CODE_L1C  = 1;   % obs code: L1C/A,G1C/A,E1C (GPS,GLO,GAL,QZS,SBS)
        CODE_L1P  = 2;   % obs code: L1P,G1P,B1P (GPS,GLO,BDS)
        CODE_L1W  = 3;   % obs code: L1 Z-track (GPS)
        CODE_L1Y  = 4;   % obs code: L1Y (GPS)
        CODE_L1M  = 5;   % obs code: L1M (GPS)
        CODE_L1N  = 6;   % obs code: L1codeless,B1codeless (GPS,BDS)
        CODE_L1S  = 7;   % obs code: L1C(D) (GPS,QZS)
        CODE_L1L  = 8;   % obs code: L1C(P) (GPS,QZS)
        CODE_L1E  = 9;   % obs code: L1C/B (QZS)
        CODE_L1A  = 10;  % obs code: E1A,B1A (GAL,BDS)
        CODE_L1B  = 11;  % obs code: E1B (GAL)
        CODE_L1X  = 12;  % obs code: E1B+C,L1C(D+P),B1D+P (GAL,QZS,BDS)
        CODE_L1Z  = 13;  % obs code: E1A+B+C,L1S (GAL,QZS)
        CODE_L2C  = 14;  % obs code: L2C/A,G1C/A (GPS,GLO)
        CODE_L2D  = 15;  % obs code: L2 L1C/A-(P2-P1) (GPS)
        CODE_L2S  = 16;  % obs code: L2C(M) (GPS,QZS)
        CODE_L2L  = 17;  % obs code: L2C(L) (GPS,QZS)
        CODE_L2X  = 18;  % obs code: L2C(M+L),B1_2I+Q (GPS,QZS,BDS)
        CODE_L2P  = 19;  % obs code: L2P,G2P (GPS,GLO)
        CODE_L2W  = 20;  % obs code: L2 Z-track (GPS)
        CODE_L2Y  = 21;  % obs code: L2Y (GPS)
        CODE_L2M  = 22;  % obs code: L2M (GPS)
        CODE_L2N  = 23;  % obs code: L2codeless (GPS)
        CODE_L5I  = 24;  % obs code: L5I,E5aI (GPS,GAL,QZS,SBS)
        CODE_L5Q  = 25;  % obs code: L5Q,E5aQ (GPS,GAL,QZS,SBS)
        CODE_L5X  = 26;  % obs code: L5I+Q,E5aI+Q,L5B+C,B2aD+P (GPS,GAL,QZS,IRN,SBS,BDS)
        CODE_L7I  = 27;  % obs code: E5bI,B2bI (GAL,BDS)
        CODE_L7Q  = 28;  % obs code: E5bQ,B2bQ (GAL,BDS)
        CODE_L7X  = 29;  % obs code: E5bI+Q,B2bI+Q (GAL,BDS)
        CODE_L6A  = 30;  % obs code: E6A,B3A (GAL,BDS)
        CODE_L6B  = 31;  % obs code: E6B (GAL)
        CODE_L6C  = 32;  % obs code: E6C (GAL)
        CODE_L6X  = 33;  % obs code: E6B+C,LEXS+L,B3I+Q (GAL,QZS,BDS)
        CODE_L6Z  = 34;  % obs code: E6A+B+C,L6D+E (GAL,QZS)
        CODE_L6S  = 35;  % obs code: L6S (QZS)
        CODE_L6L  = 36;  % obs code: L6L (QZS)
        CODE_L8I  = 37;  % obs code: E5abI (GAL)
        CODE_L8Q  = 38;  % obs code: E5abQ (GAL)
        CODE_L8X  = 39;  % obs code: E5abI+Q,B2abD+P (GAL,BDS)
        CODE_L2I  = 40;  % obs code: B1_2I (BDS)
        CODE_L2Q  = 41;  % obs code: B1_2Q (BDS)
        CODE_L6I  = 42;  % obs code: B3I (BDS)
        CODE_L6Q  = 43;  % obs code: B3Q (BDS)
        CODE_L3I  = 44;  % obs code: G3I (GLO)
        CODE_L3Q  = 45;  % obs code: G3Q (GLO)
        CODE_L3X  = 46;  % obs code: G3I+Q (GLO)
        CODE_L1I  = 47;  % obs code: B1I (BDS) (obsolete)
        CODE_L1Q  = 48;  % obs code: B1Q (BDS) (obsolete)
        CODE_L5A  = 49;  % obs code: L5A SPS (IRN)
        CODE_L5B  = 50;  % obs code: L5B RS(D) (IRN)
        CODE_L5C  = 51;  % obs code: L5C RS(P) (IRN)
        CODE_L9A  = 52;  % obs code: SA SPS (IRN)
        CODE_L9B  = 53;  % obs code: SB RS(D) (IRN)
        CODE_L9C  = 54;  % obs code: SC RS(P) (IRN)
        CODE_L9X  = 55;  % obs code: SB+C (IRN)
        CODE_L1D  = 56;  % obs code: B1D (BDS)
        CODE_L5D  = 57;  % obs code: L5D(L5S),B2aD (QZS,BDS)
        CODE_L5P  = 58;  % obs code: L5P(L5S),B2aP (QZS,BDS)
        CODE_L5Z  = 59;  % obs code: L5D+P(L5S) (QZS)
        CODE_L6E  = 60;  % obs code: L6E (QZS)
        CODE_L7D  = 61;  % obs code: B2bD (BDS)
        CODE_L7P  = 62;  % obs code: B2bP (BDS)
        CODE_L7Z  = 63;  % obs code: B2bD+P (BDS)
        CODE_L8D  = 64;  % obs code: B2abD (BDS)
        CODE_L8P  = 65;  % obs code: B2abP (BDS)
        CODE_L4A  = 66;  % obs code: G1aL1OCd (GLO)
        CODE_L4B  = 67;  % obs code: G1aL1OCd (GLO)
        CODE_L4X  = 68;  % obs code: G1al1OCd+p (GLO)
        CODE_L6D  = 69;  % obs code: B3A(D) (BDS)
        CODE_L6P  = 70;  % obs code: B3A(P) (BDS)
        MAXCODE   = 70;  % max number of obs code
    end
end
