function ch = DLL(ch)

N = max(1, floor(ch.config.T_DLL / ch.tCodeCyc));  % Calculate N (integer value, max with 1)
ch.trk.sumP4Dll = ch.trk.sumP4Dll + abs(ch.trk.C(1));  % Non-coherent sum for P
ch.trk.sumE = ch.trk.sumE + abs(ch.trk.C(2));  % Non-coherent sum for E
ch.trk.sumL = ch.trk.sumL + abs(ch.trk.C(3));  % Non-coherent sum for L
B_DLL=ch.config.B_DLL;

if mod(ch.lockCount, N) == 0
%% Discriminator
    E = ch.trk.sumE;
    L = ch.trk.sumL;
    errCode = (E - L) / (E + L)*(1-ch.config.SP_CORR); % Code error (chip)
%%  Loop filter
switch ch.config.orderDLL
    case 1 % 1st order
        errCode = errCode*ch.tCodeCyc / length(ch.code);  % covnert the unit from chip to second
        ch.codeOffset = ch.codeOffset + B_DLL * errCode;
    case 2 % 2nd order
        errCode = (E - L) / (E + L) / 2.0 ; % dimensionless quantity
        % constant
        a2=1.414;

        wn=4*a2/(1+a2*a2)*ch.config.B_DLL;
        b0=a2*wn+ch.config.T_DLL*wn*wn/2;
        b1=-a2*wn+ch.config.T_DLL*wn*wn/2;

        ch.trk.nco=b0*errCode+b1*ch.trk.errCodeOld+ch.trk.ncoOld;

        % update new parameters
        ch.trk.errCodeOld=errCode;
        ch.trk.ncoOld=ch.trk.nco;

        % Modify code freq based on NCO command
        ch.trk.codeFreq = ch.codeRate - ch.trk.nco;
end  
    
    % save results
    numEpoch= round(ch.time/ch.tCodeCyc);
    ch.result.correlationP(numEpoch)=ch.trk.sumP4Dll;
    ch.result.correlationE(numEpoch)=ch.trk.sumE;
    ch.result.correlationL(numEpoch)=ch.trk.sumL;
    ch.result.filDLLDiscr(numEpoch)=ch.trk.errCodeOld;
    ch.result.codeOffset(numEpoch)=ch.codeOffset;

    % Reset sums after update
    ch.trk.sumP4Dll = 0.0;
    ch.trk.sumE = 0.0;
    ch.trk.sumL = 0.0;

    
end