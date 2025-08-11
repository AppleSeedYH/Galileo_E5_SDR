function sequenceOut = sampleSequence(code, codeLength, chipRate, offset, samplingRate, lengthSamples)
    % SAMPLE_SEQUENCE - Samples a given sequence with specified parameters.
    %
    % Inputs:
    %   sequence       - Input sequence (array of numbers).
    %   chip_rate      - Chip rate of the sequence (Hz).
    %   offset         - Desired time offset (seconds).
    %   sampling_rate  - Sampling rate for output (Hz).
    %   length_samples - Number of samples to generate.
    %
    % Output:
    %   sampled_sequence - Sampled sequence based on input parameters.
    
    % Calculate the time step for the chip rate and sampling rate
    chipPeriod = 1 / chipRate;      % Time between chips
    samplePeriod = 1 / samplingRate;

    sampleTime=offset+(0:lengthSamples-1)*samplePeriod;

    idx=floor(sampleTime/chipPeriod);
    % the index is out of the chip number, adjust it.
    idx = 1+mod(idx, codeLength);

    sequenceOut=code(idx);
   
end
