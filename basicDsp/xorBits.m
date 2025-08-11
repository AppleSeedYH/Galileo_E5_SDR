function result = xorBits(X)
    % Convert X to a binary string and count the number of '1's
    numOnes = sum(dec2bin(X) == '1');
    % Compute XOR of all bits (0 if even count, 1 if odd)
    result = mod(numOnes, 2);
end