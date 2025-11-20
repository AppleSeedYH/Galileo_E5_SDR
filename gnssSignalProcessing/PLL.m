function ch = PLL(ch)
%% PLL
% PLL order is fixed (2nd order)

IP = real(ch.trk.C(1));  % First element of C
QP = imag(ch.trk.C(1));  % First element of C

if IP ~= 0
    if ch.costas
        errPhas = atan(QP / IP);
    else
        errPhas = atan2(QP, IP);
    end

    errPhas=errPhas/(2*pi);
    W = ch.config.B_PLL / 0.53;
    ch.dopFreq = ch.dopFreq + 1.4 * W * (errPhas - ch.trk.errPhas) + W^2 * errPhas * ch.tCodeCyc;
    ch.trk.errPhas = errPhas;
end
