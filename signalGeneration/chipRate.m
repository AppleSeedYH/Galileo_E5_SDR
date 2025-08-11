function rate = chipRate(sig)
    % Convert the signal code to uppercase
    sig = upper(sig);

    % Determine the frequency based on signal code
    switch sig
        case {'L1CA'}
            rate = 1.023e6;
        case {'E5BI', 'E5BQ', 'E5AI', 'E5AQ'}
            rate = 10.23e6;
        
    end
end
