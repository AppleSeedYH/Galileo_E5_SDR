function [ch] = initChannel(config)

for i=1:config.chNumber
    ch(i).status    = 'SRCH';
    ch(i).time      = 0.0;
    ch(i).sig       = config.sig;
    ch(i).prn       = config.prn(i);
    ch(i).sat       = satId(ch(i).sig,ch(i).prn);
    ch(i).code      = genCode(ch(i).sig,ch(i).prn);
    ch(i).codeRate  = chipRate(ch(i).sig);
    ch(i).codeLength= length(ch(i).code);
    ch(i).secCode   = genSecCode(ch(i).sig,ch(i).prn);
    ch(i).secCodeLength = length(ch(i).codeLength);
    ch(i).carFreq   = sigFreq(ch(i).sig);
    ch(i).sampleFreq= config.sampleFreq;
    ch(i).interFreq = config.interFreq;
    ch(i).tCodeCyc  = codeCyc(ch(i).sig); % the time (s) for one period of PRN code
    ch(i).numSample = double(int32(ch(i).sampleFreq*ch(i).tCodeCyc)); % number of sample in a code cycle
    ch(i).dopFreq   = 0.0;                     % Doppler frequency (Hz)
    ch(i).codeOffset= 0.0;                   % code offset (s)
    ch(i).adr       = 0.0;                    % accumulated Doppler (cyc)
    ch(i).cn0       = 0.0;                    % C/N0 (dB-Hz)
    ch(i).lockCount = 0;                     % lock count
    ch(i).lostCount = 0;                     % signal lost count
    ch(i).errCode   = 0;
    ch(i).costas    = true;
    ch(i).chOrder   = i;                    % the i-th channel;

    % new data based on C program
    ch(i).state     = 0;  % channel state 
    ch(i).week      = 0;  % week number (week)
    ch(i).tow       = 0;  % TOW (ms)
    ch(i).tow_v     = 0;  % TOW flag (0:invalid,1:valid,2:amb-unresolved)

    ch(i).acq=acqNew(ch(i),config.MAX_DOP);
    ch(i).trk=trkNew(ch(i),config);
    ch(i).nav = navNew();
    ch(i).result=initResult(config);
    ch(i).config=config;

end
