% save results for plotting
function [ch] = saveResult(ch,numEpoch)
% T_DLL=0.010;
%% for carrier loop
ch.result.iqScatter(numEpoch)=ch.trk.C(1);
ch.result.adr(numEpoch)=ch.adr;
%ch.result.rawPLLDiscr(numEpoch)=ch.trk.errPhas;
ch.result.filPLLDiscr(numEpoch)=ch.trk.errPhas;
ch.result.dopFreq(numEpoch)=ch.dopFreq;
%% for code loop
% N = max(1, floor(ch.config.T_DLL / ch.tCodeCyc));  % Calculate N (integer value, max with 1)