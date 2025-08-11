function data = readData(fid, config, secondToRead)

sampleToRead=config.IQ*config.sampleFreq*secondToRead;

[data, cntData] = fread(fid, sampleToRead, config.sampleBitWidth);
% if config.IQ==2 % for USRP
%     data = data(1:2:end) + 1i*data(2:2:end); % notation of Q
% elseif config.IQ==3 % for the original data
%     data = data(1:2:end) - 1i*data(2:2:end); % notation of Q
% end
if config.IQ==2 %% IQ
    data = data(1:2:end) + 1i*data(2:2:end); % notation of Q
end