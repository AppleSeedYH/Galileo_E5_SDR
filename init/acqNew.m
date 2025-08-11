function [acq]=acqNew(ch,dopMax)

%% zero padded fft of PRN code
% sample PRN code in one period using the sampling freuqency
resampCode=resCode(ch.code, ch.tCodeCyc, ch.codeOffset, ch.sampleFreq, ch.numSample, ch.numSample);
% do FFT
acq.codeFFT=fft(resampCode);

%% doppler bins
dopStep=0.5;
% dopStep=0.01;
acq.dopBins=-dopMax:dopStep/ch.tCodeCyc:dopMax;

%%
% non-coherent sum of corr.powers
acq.pSum=zeros(size(acq.dopBins,2),ch.numSample);
% number of non-coherent sum
acq.nSum=0;
