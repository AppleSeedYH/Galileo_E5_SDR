function [code] = readCodeHex(str,N)
CHIP=[-1,1];
code=zeros(1,N);
str=char(str);

for i = 1:N
    % Convert the corresponding hex character to a decimal integer
    hexValue = hex2dec(str(floor((i - 1) / 4) + 1));
        
    % Shift the bits and extract the required bit
    code(i) = CHIP(bitand(bitshift(hexValue, -(3 - mod(i - 1, 4))), 1) + 1);
       
end