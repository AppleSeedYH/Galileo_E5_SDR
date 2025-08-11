function probeData(fid, config)
%Function plots raw data information: time domain plot, a frequency domain
%plot and a histogram.
%
%   probeData(settings)
%
%   Inputs:
%       settings        - receiver settings. Type of data file, sampling
%                       frequency and the default filename are specified
%                       here.

%--- The frequency spectrum comes from the function test_raw_samples.m

%% Generate plot of raw data ============================================
if config.doProbeData
    fprintf('\n  +---------------------  Raw data probing -----------------------+\n');
    
    try
        %--- Move the starting point of processing
        skp_factor = computeSkipFactor(config);
        
        %--- check if it starts from I or Q sample
        flagFirstQ = isTheFirstSamplesQ(config);
        
        fseek(fid,config.skipNumberOfBytes * skp_factor + flagFirstQ ,'bof');
        
        %--- Read samples
        seconds = 20e-3;
        data = readData(fid,config,seconds);
        
        %--- Spectrum of received signal samples
        Nfft = 512;                   % number of FFT points
        Nover = 0;                    % samples of overlap from section to section
        Wind = boxcar(Nfft);          % Welch window
        switch config.IQ
            case 2
                Side = 'twosided';        % Side flag
            case 1
                Side = 'onesided';        % Side flag
            otherwise
                disp 'Wrong sampling mode'
        end
        
        % data = data - mean(data); % Mean value removal (in order to remove DC component)
        
        [S, Frequency] = pwelch(data, Wind, Nover, Nfft, config.sampleFreq, Side);   % Welch spectrum
        
        SignalSpectrum=S;
        % SignalSpectrum = S.*FreqSamp;                  % spectrum normalization wrt the sampling frequency
        % SignalSpectrum = SignalSpectrum./max(SignalSpectrum); %  spectrum normalization wrt its maximum
        
        if strcmp(Side,'twosided')                      % spectrum and frequency shift (if the twosided option is chosen)
            SignalSpectrum = fftshift(SignalSpectrum);
            Frequency = Frequency - config.sampleFreq/2;
        end
        
        %--- Initialization ---------------------------------------------------
        figure(100);
        clf(100);
        set(100, 'Name', ['Probe raw GNSS data: ' config.sampleFilePath]);
        
        timeScale = 1/config.sampleFreq : 1/config.sampleFreq : seconds;
        
        %--- Time domain plot -------------------------------------------------
        subplot(2, 2, 1);
        plot(1000 * timeScale(1:ceil(0.001*config.sampleFreq)), ...
            real(data(1:ceil(0.001*config.sampleFreq))), ...
            'Color',[220/255,50/255,100/255]);
        
        axis tight;
        grid on;
        title ('Time domain plot');
        xlabel('Time (ms)');
        ylabel('Amplitude');
        
        %--- Histogram --------------------------------------------------------
        subplot(2, 2, 2);
        histogram(real(data), 100)
        
        dmax = max(abs(data)) + 1;
        axis tight;
        adata = axis;
        axis([-dmax dmax adata(3) adata(4)]);
        grid on;
        title ('Histogram');
        xlabel('Bin'); ylabel('Number in bin');
        
        %--- Frequency domain plot --------------------------------------------
        subplot(2,2,[3 4]);
        
        plot(Frequency./1e6, 10*log10(SignalSpectrum),'Linewidth', 2, 'Color',[232/255,100/255,45/255]),
        xlabel('Frequency (MHz)');
        ylabel('Power Spectral Density (dB/Hz)');
        axis tight;
        grid on;
        title ('Frequency domain plot');
        
        % if config.saveProbeData
        %     saveas(100, fullfile(config.workingPath, '/ProbeData_L1.png'));
        % end
    catch
        %--- There was an error, print it and exit
        errStruct = lasterror;
        disp(errStruct.message);
        disp('Error in function probeData.');
        return;
    end
end