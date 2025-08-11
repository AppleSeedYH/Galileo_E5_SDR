function [code] = genCodeE5AI(prn,E5AIX2Init)

if prn<1 || prn >50
    fprintf('\n  +------------------  prn out of range  ------------------+\n');
    return 
end
N=10230;
E5AIX2InitDec=oct2dec(E5AIX2Init);% covert from octal to decimal
code1 = genCodeE5X1(N, 16707);
code2 = genCodeE5X2(N, 20913, E5AIX2InitDec(prn));
code = -code1 .* code2;