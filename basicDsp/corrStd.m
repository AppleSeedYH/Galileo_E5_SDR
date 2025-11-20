% mix carrier and standard correlator
%  Parallel code search in digitized IF data.
%
%  args:
%      buffer   (I) RX IF samples
%      ix       (I) Index of buffer
%      fs       (I) Sampling frequency (Hz)
%      fi       (I) IF frequency (Hz)
function [corrResult] = corrStd(buffer, ix, N, fs, carFreq, phi, code)
%% mix carrier
% generate local carrier
phase=2*pi*phi+(0:N-1)*2*pi*carFreq/fs;
localCarrier=exp(-1i*phase);
% mix
if ix==0 % add 0 at beginning for this special case
    % workaround: when you are supposed to start from 0 (not allowed index) you start
    % from 1 and add a zero value to match dimensions (loosing one sample
    % in the correlation)
    data=[0,buffer(1:ix+N-1)].*localCarrier;
else
    data=buffer(ix:ix+N-1).*localCarrier;
end
%% mix code
corrResult = zeros(1, 4);   % Initialize correlation array as a row vector

for i=1:4
    % corrResult(i)= conj(dot(data, code(i,:)) / N);
    corrResult(i)=sum(data.* code(i,:))/N;
end