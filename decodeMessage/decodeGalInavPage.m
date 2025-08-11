function ch = decodeGalINAVPage(ch, syms, rev)
%DECODE_GAL_INAV   Decode Galileo I/NAV page from symbol stream
%
%   ch = decode_gal_INAV(ch, syms, rev)
%
% Inputs:
%   ch.nav.syms   – buffer of recent symbols (unused here)
%   syms          – 500×1 uint8 vector of symbols for this page
%   rev           – bit‐inversion flag (0 or 1)
%
% Outputs:
%   ch            – updated channel struct
%%
TOFF_E1B=2.037;         %time offset (s) E1B
TOFF_E5BI=2.040;        %time offset (s) E5BI
GPST_GST_W=1024;        %GPST - GST (week)
%%
    % choose time offset for E1B vs E5BI
    if strcmp(ch.sig,'E1B')
        toff = TOFF_E1B;
    else
        toff = TOFF_E5BI;
    end
    time_rec = ch.time - toff;
    
    % invert symbols by revision bit
    buff = bitxor(syms, rev);
    
    % prepare bit‐ and byte‐buffers
    bits = zeros(228,1);    % 114 even + 114 odd bits
    data = zeros(16,1);     % 16‐byte I/NAV word
    
    % decode two halves of 240 symbols → 114 bits each
    % C: decode_gal_syms(buff+10, 30,8, bits)
    bits(1:114)     = decodeGalSyms(buff(11:250), 30, 8);
    % C: decode_gal_syms(buff+260,30,8, bits+114)
    bits(115:228)   = decodeGalSyms(buff(261:500),30, 8);
    
    % check even/odd sync bits: bits(1)==0, bits(115)==1
    if bits(1) ~= 0 || bits(115) ~= 1
        ch.nav.ssync = 0;
        ch.nav.fsync = 0;
        ch.nav.rev   = 0;
        return;
    end
    
    
    %Creates a cyclic redundancy code (CRC) detector System object
    crcDet = comm.CRCDetector([24 23 18 17 14 11 10 7 6 5 4 3 1 0]);
    % CRC‐check the first 220 bits
    [~,crcError] = step(crcDet,bits);

    if crcError
        % on success, lock in page sync
        ch.nav.ssync = ch.lockCount;
        ch.nav.fsync = ch.lockCount;
        ch.nav.rev   = rev;
        
        % pack 112 “I” bits then 16 “Q” bits into 16‐byte word
        navWord=zeros(128,1);
        navWord(1:112)=bits(3:114);
        navWord(113:128)=bits(117:132);

        navWord=dec2bin(logical(navWord))'; % covert double to char
        
        % extract word type from first 6 bits
        type = bin2dec(navWord(1:6));
        ch.nav.type = type;
        
        % if it’s a TOW page, update week and TOW
        if type == 5
            ch.week = bin2dec(navWord(74:85)) + GPST_GST_W;
            ch = updateTow(ch, bin2dec(navWord(86:105)) + toff);
        end
        
        % store the 16‐byte word in the appropriate slot
        if type >= 0 && type <= 6
            % idx = 16*type + (1:16);
            ch.nav.data{type+1} = navWord;
        end
        
        % mark valid and bump counter
        ch.nav.stat     = 1;
        ch.nav.count(1) = ch.nav.count(1) + 1;
        
        % log hex dump of word
        % str = hex_str(data, 128);
        % sdr_log(3, sprintf('$INAV,%.3f,%s,%d,%s', ...
        %     time_rec, ch.sig, ch.prn, str));
    else
        % CRC failure: unsync and log error
        ch = unsyncNav(ch);
        ch.nav.count(2) = ch.nav.count(2) + 1;
        % sdr_log(4, sprintf('$LOG,%.3f,%s,%d,INAV FRAME ERROR', ...
        %     time_rec, ch.sig, ch.prn));
    end
end
