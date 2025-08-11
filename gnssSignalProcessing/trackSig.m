function [ch]=trackSig(ch,time,buffer)
%% udpate status
timeIntv= time-ch.time; % time interval (s)
carFreq = ch.interFreq + ch.dopFreq; % IF carrier frequency with Doppler (Hz)
ch.adr = ch.adr + ch.dopFreq * timeIntv; % accumulated Doppler (cycle)
ch.codeOffset = ch.codeOffset - ch.dopFreq/ch.carFreq * timeIntv; % carrier-aided code offset(s)
ch.time = time;
numEpoch= round(time/ch.tCodeCyc);

%% If offset exceeds one period, subtract period
% pay attention, should the time also be adjusted?
if ch.codeOffset >= ch.tCodeCyc
    ch.codeOffset = ch.codeOffset - ch.tCodeCyc;
    ch = adjustTow(ch, -ch.tCodeCyc);
    ch.lockCount = ch.lockCount - 1;
    % shift history forward: drop oldest sample
    ch.trk.P(2:end) = ch.trk.P(1:end-1);

    % ch.trk.secSync = ch.trk.secSync - 1;
    % ch.nav.fsync = ch.nav.fsync -1;
    % ch.nav.ssync = ch.nav.ssync -1;
% If offset is negative, add period
elseif ch.codeOffset < 0
    ch.codeOffset = ch.codeOffset + ch.tCodeCyc;
    ch = adjustTow(ch, ch.tCodeCyc);
    ch.lockCount = ch.lockCount + 1;
    ch.trk.secSync = ch.trk.secSync + 1;
    % shift history backward: drop newest sample
    ch.trk.P(1:end-1) = ch.trk.P(2:end);
    
    % ch.trk.secSync = ch.trk.secSync + 1;
    % ch.nav.fsync = ch.nav.fsync +1;
    % ch.nav.ssync = ch.nav.ssync +1;
end

%% determine the received samples to do correlation
i = floor(ch.codeOffset * ch.sampleFreq);
codeOffset = -(ch.codeOffset-i/ch.sampleFreq);  % unit: s
phi = ch.interFreq * timeIntv + ch.adr + carFreq * double(i-1) / ch.sampleFreq;       % Compute phi
spacingOffset = ch.config.SP_CORR*(1/ch.codeRate);

% update offset
ch.codeOffset=ch.codeOffset+(ch.codeLength/ch.trk.codeFreq)-ch.tCodeCyc;

localCode=zeros(4,ch.numSample);
% generate prompt code
localCode(1,:)=sampleSequence(ch.code, ch.codeLength, ch.codeRate, codeOffset, ch.sampleFreq, ch.numSample);
% generate early code
localCode(2,:)=sampleSequence(ch.code, ch.codeLength, ch.codeRate, codeOffset-spacingOffset, ch.sampleFreq, ch.numSample);
% generate late code
localCode(3,:)=sampleSequence(ch.code, ch.codeLength, ch.codeRate, codeOffset+spacingOffset, ch.sampleFreq, ch.numSample);
% generate code for C/N0
localCode(4,:)=sampleSequence(ch.code, ch.codeLength, ch.codeRate, codeOffset-(10/ch.codeRate), ch.sampleFreq, ch.numSample);

% ch.trk.C=corrStdTest(buffer, i, ch.numSample, ch.sampleFreq, carFreq, phi, localCode);
%% standard correlator
ch.trk.C=corrStd(buffer, i, ch.numSample, ch.sampleFreq, carFreq, phi, localCode);

% add P correlator outputs to history
ch.trk.P(1:end-1) = ch.trk.P(2:end);     % Shift all elements to the left
ch.trk.P(end) = ch.trk.C(1);             % Insert the new item at the end
ch=adjustTow(ch, ch.tCodeCyc);
ch.lockCount=ch.lockCount+1;

%% Sync and remove secondary code
lenSec=length(ch.secCode);
if lenSec>=2 & ch.lockCount * ch.tCodeCyc >= ch.config.T_NPULLIN
    ch=syncSecCode(ch,lenSec);
end
%% FLL/PLL, DLL and update C/N0
if ch.lockCount * ch.tCodeCyc <= ch.config.T_FPULLIN
    ch=FLL(ch);
else
    ch=PLL(ch);
end
ch=DLL(ch);
ch=CN0(ch);
%% decode navigaiton messages
if ch.lockCount * ch.tCodeCyc >= ch.config.T_NPULLIN
    ch = navDecode(ch);
end
%% save result for plotting
ch = saveResult(ch,numEpoch);
%% display information for debugging
% if ch.tow > 0
%     fprintf('sat %d: tow=%d ',ch.prn, ch.tow);
% end
fprintf('sat %s ',ch.sat);
fprintf('cn0=%.3f ',ch.cn0);
%fprintf('dop=%d ',ch.dopFreq);
%fprintf('adr=%d ',ch.adr);
%fprintf('coff=%d\n',ch.codeOffset);
%% check if lose lock
if ch.cn0<ch.config.THRES_CN0(2)
    ch.status='IDLE';
    ch.lostCount=ch.lostCount+1;
end
