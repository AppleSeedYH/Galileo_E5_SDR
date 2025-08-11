function [code] = genCodeE5BI(prn,E5BIX2Init)

if prn<1 || prn >50
    fprintf('\n  +------------------  prn out of range  ------------------+\n');
    return 
end
N=10230;
E5BIX2InitDec=oct2dec(E5BIX2Init);% covert from octal to decimal
code1 = genCodeE5X1(N, 26641);
code2 = genCodeE5X2(N, 21285, E5BIX2InitDec(prn));
code = -code1 .* code2;
end