function crc = calculateCRC24Q(data)
    % calculateCRC24Q computes the CRC24Q checksum for a given input.
    % 
    % Input:
    %   data - A row vector of uint8 values (bytes) representing the input data.
    % 
    % Output:
    %   crc - A 24-bit CRC24Q checksum as a uint32 value.
    
    % Define the CRC24Q polynomial: 0x1864CF in hexadecimal
    POLY = hex2dec('1864CF');
    
    % Initial CRC value (usually set to 0 in CRC24Q)
    crc = 0; 
    
    % Process each byte in the input data
    for byte = data
        % XOR the input byte with the top 8 bits of the CRC
        crc = bitxor(crc, bitshift(uint32(byte), 16));
        
        % Perform 8 iterations of the CRC algorithm (1 for each bit in the byte)
        for bit = 1:8
            if bitand(crc, bitshift(1, 23)) ~= 0
                % If the MSB (most significant bit) is set, XOR with the polynomial
                crc = bitxor(bitshift(crc, 1), POLY);
            else
                % Otherwise, just shift left
                crc = bitshift(crc, 1);
            end
        end
    end
    
    % Mask the CRC to ensure it's 24 bits
    crc = bitand(crc, hex2dec('FFFFFF'));
end
