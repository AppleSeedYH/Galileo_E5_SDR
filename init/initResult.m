% save results to a file
function [result] = initResult(config)
% the number of epochs
tCoh=codeCyc(config.sig);
N = floor(config.sToProcess/tCoh);


result.timeStamp=(1:N)*tCoh;
result.iqScatter=complex(NaN(1,N),0);
result.correlationP=NaN(1,N);
result.correlationE=NaN(1,N);
result.correlationL=NaN(1,N);
result.adr=NaN(1,N);
result.rawPLLDiscr=NaN(1,N);
result.filPLLDiscr=NaN(1,N);
result.rawDLLDiscr=NaN(1,N);
result.filDLLDiscr=NaN(1,N);
result.codeOffset=NaN(1,N);
result.dopFreq=NaN(1,N);