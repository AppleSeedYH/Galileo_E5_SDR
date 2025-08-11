function freq = sigFreq(sig)
    % Convert the signal code to uppercase
    sig = upper(sig);

    % Determine the frequency based on signal code
    switch sig
        case {'L1CA', 'L1CB', 'L1S' , 'E1B', 'E1C', 'L1CP', 'L1CD', 'B1CD', 'B1CP', 'I1SD', 'I1SP'}
            freq = 1575.42e6;
        case {'L2CM', 'L2CL'}
            freq = 1227.60e6;
        case {'L5I', 'L5Q', 'L5SI', 'L5SIV', 'L5SQ', 'L5SQV', 'E5AI', 'E5AQ', 'B2AD', 'B2AP', 'I5S'}
            freq = 1176.45e6;
        case {'E5BI', 'E5BQ', 'B2I', 'B2BI'}
            freq = 1207.14e6;
        case {'L6D', 'L6E', 'E6B' , 'E6C'}
            freq = 1278.75e6;
        case 'B1I'
            freq = 1561.098e6;
        case 'B3I'
            freq = 1268.52e6;
        case 'G1CA'
            freq = 1602.0e6;
        case {'G1OCD', 'G1OCP'}
            freq = 1600.995e6;
        case 'G2CA'
            freq = 1246.0e6;
        case 'G2OCP'
            freq = 1248.0e6;
        case {'G3OCD', 'G3OCP'}
            freq = 1202.025e6;
        case 'ISS'
            freq = 2492.028e6;
        otherwise
            freq = 0.0;
    end
end
