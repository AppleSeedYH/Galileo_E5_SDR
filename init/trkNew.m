% function [trk] = trkNew(sig, prn, code, tCodeCyc, fs, config,config.SP_CORR, add_corr, N_)
function [trk] = trkNew(ch,config)
    % Initialize tracking structure as a struct in MATLAB
    trk = struct();

    % Calculate position and set correlator positions {P, E, L, N}
    pos = floor(config.SP_CORR * ch.tCodeCyc / length(ch.code) * ch.sampleFreq) + 1;
    trk.pos = [0, -pos, pos, -80];

    % Additional correlator positions if add_corr > 0
    if config.ADD_CORR > 0
        trk.pos = [trk.pos, -config.ADD_CORR:config.ADD_CORR];
    end

    % Initialize correlator outputs and history of P correlator outputs
    trk.C = complex(zeros(1, length(trk.pos))); % Complex output for correlators
    trk.P = complex(zeros(1, config.N_HIST));          % History of P correlator outputs

    % Initialize secondary code sync and polarity, carrier phase error, and sum of correlator outputs
    trk.secSync = 0;
    trk.secPol = 0;
    trk.errPhas = 0.0;
    trk.sumP = 0.0;
    trk.sumE = 0.0;
    trk.sumL = 0.0;
    trk.sumN = 0.0;
    trk.sumP4Dll=0;

    % Preallocate code array
    trk.code = cell(1, config.N_CODE);

    % Generate code for each value in config.N_CODE
    for i = 1:config.N_CODE
        coff = - (i - 1) / ch.sampleFreq / config.N_CODE; % MATLAB indexing starts at 1
        if strcmp(config.sig, 'L6D') || strcmp(config.sig, 'L6E')
            trk.code{i} = gen_code_fft(ch.code, ch.tCodeCyc, coff, ch.sampleFreq, floor(ch.sampleFreq * ch.tCodeCyc));
        else
            trk.code{i} = resCode(ch.code, ch.tCodeCyc, coff, ch.sampleFreq, floor(ch.sampleFreq * ch.tCodeCyc));
        end
    end
end
