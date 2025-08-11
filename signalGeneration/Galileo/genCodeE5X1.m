function [code]=genCodeE5X1(N,tap)
tap = bitshift(tap, -1);
tap = revReg(tap,14);
code = LFSR(N, 16383, tap, 14);
end