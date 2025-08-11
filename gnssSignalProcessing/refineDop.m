function fd = refineDop(P, fds, ix)
    % Check if the index is at the boundaries of the array
    if ix == 1 || ix == length(fds)
        fd = fds(ix);
        return;
    end
    
    % Perform quadratic fitting with polyfit on the surrounding Doppler bins
    p = polyfit(fds(ix-1:ix+1), P(ix-1:ix+1), 2);
    
    % Calculate fine Doppler frequency
    fd = -p(2) / (2.0 * p(1));
end
