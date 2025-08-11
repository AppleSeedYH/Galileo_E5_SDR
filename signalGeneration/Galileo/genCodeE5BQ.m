function [code] = genCodeE5BQ(prn,E5BQX2Init)

if prn<1 || prn >50
    fprintf('\n  +------------------  prn out of range  ------------------+\n');
    return 
end
N=10230;
E5BQX2InitDec=oct2dec(E5BQX2Init);% covert from octal to decimal
code1 = genCodeE5X1(N, 26641);
code2 = genCodeE5X2(N, 18019, E5BQX2InitDec(prn));
code = -code1 .* code2;
end