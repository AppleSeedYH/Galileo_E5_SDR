function [config, fid] = openSampleFile(config)

%--- Open the signal. If success, then process the data, else stop execution
[fid, message] = fopen(config.sampleFilePath, 'rb');

if fid < 1
    fprintf('Error: unable to read file %s\n%s.\nExiting...\n', config.sampleFilePath, message);
    fclose(fid);
    config.exit = 1;
end
%% skip some seconds
switch config.sampleBitWidth
    case 'int8'
        bytesPerSample = 1; % int8 uses 1 byte
    case 'int16'
        bytesPerSample = 2; % int16 uses 2 bytes
    otherwise
        error('Unsupported data type. Use "int8" or "int16".');
end
 samplesToSkip= config.skipSecond*config.sampleFreq*config.IQ;
 bytesToSkip = samplesToSkip * bytesPerSample;
 fseek(fid, bytesToSkip, 'bof');