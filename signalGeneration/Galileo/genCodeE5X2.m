function [code]=genCodeE5X2(N,tap,R)
R = revReg(R,14);
tap = bitshift(tap, -1);
tap = revReg(tap,14);
code = LFSR(N, R, tap, 14);
end