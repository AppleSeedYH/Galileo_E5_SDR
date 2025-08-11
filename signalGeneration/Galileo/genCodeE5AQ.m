function [code] = genCodeE5AQ(prn,E5AQX2Init)

if prn<1 || prn >50
    fprintf('\n  +------------------  prn out of range  ------------------+\n');
    return 
end
N=10230;
E5AQX2InitDec=oct2dec(E5AQX2Init);% covert from octal to decimal
code1 = genCodeE5X1(N, 16707);
code2 = genCodeE5X2(N, 20913, E5AQX2InitDec(prn));
code = -code1 .* code2;