% max correlation power and C/N0

function [pMax, ix, cn0] = corrMax(P, T)
    % Find the index of the maximum value in P
    [pMax, linearIx] = max(P(:));
    [ixRow, ixCol] = ind2sub(size(P), linearIx);
    ix = [ixRow, ixCol];
    
    % Calculate the mean of P
    pAve = mean(P(:));
    
    % Calculate C/N0 (Carrier-to-Noise Ratio)
    if pAve > 0
        cn0 = 10.0 * log10((pMax - pAve) / (pAve * T));
    else
        cn0 = 0.0;
    end
end
