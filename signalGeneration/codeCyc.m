function cycle = codeCyc(sig)
    % Convert the signal code to uppercase
    sig = upper(sig);

    % Determine the cycle time based on signal code
    switch sig
        case {'L1CA', 'L1CB', 'L1S', 'L5I', 'L5Q', 'L5SI', 'L5SIV', 'L5SQ', ...
              'L5SQV', 'G1CA', 'G2CA', 'G3OCD', 'G3OCP', 'E5AI', 'E5AQ', ...
              'E5BI', 'E5BQ', 'E6B', 'E6C', 'B1I', 'B2I', 'B2AD', 'B2AP', ...
              'B2BI', 'B3I', 'I5S', 'ISS'}
            cycle = 1e-3;
        case 'G1OCD'
            cycle = 2e-3;
        case {'L6D', 'L6E', 'E1B', 'E1C'}
            cycle = 4e-3;
        case 'G1OCP'
            cycle = 8e-3;
        case {'L1CP', 'L1CD', 'B1CD', 'B1CP', 'I1SD', 'I1SP'}
            cycle = 10e-3;
        case {'L2CM', 'G2OCP'}
            cycle = 20e-3;
        case 'L2CL'
            cycle = 1500e-3;
        otherwise
            cycle = 0.0;
    end
end