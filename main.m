%--- This is the main script

%--- Clean up the environment first
clear;
close all;
close all hidden;
clc;

format ('compact');
format ('long', 'g');

% include path
restoredefaultpath;
addpath(genpath(pwd));
%% init configurations
config = initConfig();
%% open IF sample file
[config, fid] = openSampleFile(config);
%% probe data
% probeData(fid, config)
%% init channels
ch = initChannel(config);
pvt = pvtNew(config);
%% init figures
% gcfArray = initRealTimePlot(config);
%% start process
numSample=int32(ch(1).tCodeCyc*ch(1).sampleFreq);
T=ch(1).tCodeCyc;
buffer=complex(zeros(1,2*numSample));
%bufferPre=complex(zeros(1, numSample));
i=0; % index of IF data buffer
while (i>=0)
    fprintf('\n');
    timeRcv=i*T
    % i
    
    % debug
    % if (i==469)
    %     temp=1;
    % end

    % stop processing when the mission is done
    % if (timeRcv>config.skipSecond+config.sToProcess)
    if (i>(config.sToProcess/T))
        break;
    end

    % read IF data to buffer
    buffer(1,numSample+1:end)=readData(fid, config, T);

    % prepare two cycles of prn codes, then start
    if i==0
        buffer(1,1:numSample)=buffer(1,numSample+1:end);
        i=i+1;
        continue
    end

    % update all receiver channels
    for j=1:config.chNumber
        % ch(j).timeRcv=timeRcv;

        % signal acqusiiton and tracking
        ch(j) = chUpdate(ch(j),timeRcv,buffer);
        
        % update navigation data: eph, ion, and utc info
        if (ch(j).nav.stat) 
            pvt = chUpdateNav(pvt,ch(j));
            ch(j).nav.stat=0;
        end
        
        % update observation data
        pvt = pvtUpdateObs(pvt, i, ch(j));
    end
    
    % update pvt solutions
    if i == pvt.ix
        pvt = pvtUpdateSol(pvt);
    end

    % update receiver channel status (some doubts on this part)
    if mod(i,floor(config.CYC_SRCH / T))==0
        for j=1:config.chNumber
            if ch(j).status == 'IDLE'
                ch(j).status = 'SRCH';
            end
        end
    end

    % update the buffer
    buffer(1,1:numSample)=buffer(1,numSample+1:end);
    i=i+1;

    % plot figure for real-time
    % realTimePlot(ch,gcfArray)
end
disp('process finished');
%% plot results
plotResult(ch);

