function code = LFSR(N, R, tap, n)

    CHIP=[-1,1];

    code = zeros(1, N);  % Initialize the array with int8 type

    for i = 1:N
        code(i) = CHIP(bitand(R, 1) + 1);  % MATLAB indexing starts at 1, so add 1
        
        seq1=bitshift(xorBits(bitand(R, tap)), n - 1);
        seq2=bitshift(R, -1);
        
        % Convert the decimal numbers to binary strings
        bin1 = dec2bin(seq1);
        bin2 = dec2bin(seq2);
        % Determine the lengths of the binary strings
        len1 = length(bin1);
        len2 = length(bin2);
        % Find the maximum length
        maxLength = max(len1, len2);
    
        % Pad the shorter binary string with leading zeros
        bin1 = pad(bin1, maxLength, 'left', '0');
        bin2 = pad(bin2, maxLength, 'left', '0');
    
        % Perform the OR operation bit-by-bit and store the result
        resultBin = char((bin1 == '1' | bin2 == '1') + '0');
    
        % Convert the result binary string back to a decimal number
        R = bin2dec(resultBin);
        %R = bitshift(xorBits(bitand(R, tap)), n - 1) | bitshift(R, -1);
    end
end