function [ch] = searchSig(ch, time, buffer)

ch.time = time;
% parallel code search and non-coherent integration
P = searchCode(ch.acq.codeFFT,ch.tCodeCyc,buffer,ch.sampleFreq,ch.interFreq,ch.acq.dopBins);
ch.acq.pSum=ch.acq.pSum+P;
ch.acq.nSum=ch.acq.nSum+1;

if ch.acq.nSum*ch.tCodeCyc >= ch.config.T_ACQ

    [pMax, ix, cn0] = corrMax(ch.acq.pSum, ch.tCodeCyc);

    if cn0 >= ch.config.THRES_CN0
        acqDop = refineDop(ch.acq.pSum(:,ix(2)), ch.acq.dopBins, ix(1)); %unit: Hz
        acqCodePhase = ix(2)/ch.sampleFreq; % unit: sec
        
        % acqDop=92.7;
        % acqCodePhase=0.00050001;
        % init tracking
        ch = startTrack(ch,acqDop,acqCodePhase,cn0,time);
        fprintf('Signal %s from PRN-%d is captured.\n',ch.sig, ch.prn);
    else
        ch.status='SRCH';
    end

    ch.acq.pSum(:)=0;
    ch.acq.nSum=0;
end
