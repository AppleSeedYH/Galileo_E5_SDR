function [eph, ok] = decodeGalInavEph(data, eph)
%DECODE_GAL_INAV_EPH   Decode Galileo I/NAV ephemeris page using bin2dec
%
%   [eph, ok] = decode_gal_inav_eph(buff, eph)
%
% Inputs:
%   buff – char array of '0'/'1', length 5*128 = 640 bits, concatenated I/NAV words
%   eph  – struct matching eph_t for output (preallocated)
%
% Outputs:
%   eph  – updated ephemeris struct
%   ok   – true if decoding succeeded, false otherwise

    ok = false;

    % Copy input to local variable
    eph_gal = eph;

    % Preallocate arrays
    type    = zeros(1,5);
    iod_nav = zeros(1,4);

    try
        % WORD 1 --- Ephemeris (1/4) -------------------------------------
        word=data{2};
        type(1)     = bin2dec(word(1:6));
        iod_nav(1)  = bin2dec(word(7:16));
        eph_gal.toes= bin2dec(word(17:30))              *60.0;
        eph_gal.M0  = twosComp2dec(word(31:62))          *2^(-31)*Const.galPi;
        eph_gal.e   = bin2dec(word(63:94))              *2^(-33);
        sqrtA       = bin2dec(word(95:126))             *2^(-19);

        % WORD 2 --- Ephemeris (2/4) -------------------------------------
        word=data{3};
        type(2)     = bin2dec(word(1:6));
        iod_nav(2)  = bin2dec(word(7:16));
        eph_gal.OMG0= twosComp2dec(word(17:48))          *2^(-31)*Const.galPi;
        eph_gal.i0  = twosComp2dec(word(49:80))          *2^(-31)*Const.galPi;
        eph_gal.omg = twosComp2dec(word(81:112))         *2^(-31)*Const.galPi;
        eph_gal.idot= twosComp2dec(word(113:126))        *2^(-43)*Const.galPi;

        % WORD 3 --- Ephemeris (3/4), SISA -------------------------------
        word=data{4};
        type(3)     = bin2dec(word(1:6));
        iod_nav(3)  = bin2dec(word(7:16));
        eph_gal.OMGd= twosComp2dec(word(17:40))          *2^(-43)*Const.galPi;
        eph_gal.deln= twosComp2dec(word(41:56))          *2^(-43)*Const.galPi;
        eph_gal.cuc = twosComp2dec(word(57:72))          *2^(-29);
        eph_gal.cus = twosComp2dec(word(73:88))          *2^(-29);
        eph_gal.crc = twosComp2dec(word(89:104))         *2^(-5);
        eph_gal.crs = twosComp2dec(word(105:120))        *2^(-5);
        eph_gal.sva = bin2dec(word(121:128));

        % WORD 4 --- SVID, Ephemeris (4/4), Clock Correction -------------
        word=data{5};
        type(4)     = bin2dec(word(1:6));
        iod_nav(4)  = bin2dec(word(7:16));
        svid        = bin2dec(word(17:22));
        eph_gal.cic = twosComp2dec(word(23:38))          *2^(-29);
        eph_gal.cis = twosComp2dec(word(39:54))          *2^(-29);
        toc         = bin2dec(word(55:68))              *60.0;
        eph_gal.f0  = twosComp2dec(word(69:99))          *2^(-34);
        eph_gal.f1  = twosComp2dec(word(100:120))        *2^(-46);
        eph_gal.f2  = twosComp2dec(word(121:126))        *2^(-59);

        % WORD 5 --- Iono, BGD, Signal Health, Data Validity, GST --------
        word=data{6};
        type(5)     = bin2dec(word(1:6));
        eph_gal.tgd(1) = twosComp2dec(word(48:57))   * 2^(-32);
        eph_gal.tgd(2) = twosComp2dec(word(58:67))   * 2^(-32);
        e5b_hs    = bin2dec(word(68:69));  % E5b signal Health Status (0-OK)
        e1b_hs    = bin2dec(word(70:71));  % E1-B/C signal Health Status (0-OK)
        e5b_dvs   = bin2dec(word(72));     % E5b Data validity status (0-valid)
        e1b_dvs   = bin2dec(word(73));     % E1-B Data validity status (0-valid)
        week      = bin2dec(word(74:85));
        tow       = bin2dec(word(86:105));

        % Validate word types and IOD consistency
        if ~isequal(type,1:5) || numel(unique(iod_nav))~=1
            return;
        end

        % Satellite index
        sat = satNo(Const.SYS_GAL, svid);
        if sat==0, return; end

        % Finalize fields
        eph_gal.sat  = sat;
        eph_gal.A    = sqrtA^2;
        eph_gal.iode = iod_nav(1);
        eph_gal.iodc = iod_nav(1);
        eph_gal.svh  = bitor(bitshift(e5b_hs,7),bitshift(e5b_dvs,6)) + bitshift(e1b_hs,1) + e1b_dvs;
        eph_gal.ttr  = gst2time(week,tow);
        dt = gst2time(week,eph_gal.toes) - eph_gal.ttr;
        if      dt>302400, week=week-1;
        elseif  dt<-302400, week=week+1;
        end
        eph_gal.toe  = gst2time(week, eph_gal.toes);
        eph_gal.toc  = gst2time(week, toc);
        eph_gal.week = week + 1024;
        eph_gal.code = bitshift(1,9);

        % Assign output
        eph = eph_gal;
        ok  = true;
    catch
        % any error => fail
        ok = false;
    end
end
