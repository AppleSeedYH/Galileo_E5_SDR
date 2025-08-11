%  Parallel code search in digitized IF data.
%
%  args:
%      code_fft (I) Code DFT (with or w/o zero-padding)
%      T        (I) Code cycle (period) (s)
%      buff     (I) Buffer of IF data as complex array
%      fs       (I) Sampling frequency (Hz)
%      fi       (I) IF frequency (Hz)
%      fds      (I) Doppler frequency bins as ndarray (Hz)

function P = searchCode(codeFft, T, buff, fs, fi, fds)
    % Parameters
    numberSamplePerCycle = round(fs * T); % the number of samples per code cycle
    tPerSample = 1/fs;% the time lasting for one sample
    t=(0:2*numberSamplePerCycle-1)*tPerSample; % time series of samples;
    P = zeros(length(fds), numberSamplePerCycle);
    
    % Parallel code search over Doppler frequency bins
    for i = 1:length(fds)
        
        % Generate the carrier use the frequency in the current search bin
        carrierIq=exp(-2*1i*pi*(fi+fds(i)).*t);

        mixedIqFft = fft(carrierIq.*buff);
        
        C = ifft (mixedIqFft.*conj(codeFft));
        % Correlate with FFT method
        %C = corr_fft(buff, ix, length(codeFft), fs, fi + fds(i), 0.0, codeFft);
        C = C(1:numberSamplePerCycle);
        
        % Store correlation power
        P(i, :) = abs(C) .^ 2;
    end
end