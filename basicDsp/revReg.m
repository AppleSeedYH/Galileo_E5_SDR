% reverse the bits in shift register

function result = revReg(R, N)
    % Convert R to a binary string
    binaryStr = dec2bin(R);

    % Add zeros if N is larger than the length of R
    if N > length(binaryStr)
        numZeros = N - length(binaryStr);
        zerosToAdd = repmat('0', 1, numZeros);
        binaryStr=[zerosToAdd binaryStr];
    end

    % Separate the part to be reversed and the part to remain the same
    partToReverse = binaryStr(end-N+1:end);  % Last B digits

    % Reverse the last N digits
    reversedPart = flip(partToReverse);

    result = bin2dec(reversedPart);
end