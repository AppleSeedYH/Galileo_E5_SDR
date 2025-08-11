function ch = FLL(ch)

if ch.lockCount >= 2
    IP1 = real(ch.trk.P(end));
    QP1 = imag(ch.trk.P(end));
    IP2 = real(ch.trk.P(end - 1));
    QP2 = imag(ch.trk.P(end - 1));

    dot = IP1 * IP2 + QP1 * QP2;
    cross = IP1 * QP2 - QP1 * IP2;

    if dot ~= 0
        if ch.lockCount * ch.tCodeCyc < ch.config.T_FPULLIN / 2
            B = ch.config.B_FLL(1);
        else
            B = ch.config.B_FLL(2);
        end

        if ch.costas
            errFreq = atan(cross / dot);
        else
            errFreq = atan2(cross, dot);
        end

        ch.dopFreq = ch.dopFreq - (B / 0.25) * errFreq / 2.0 / pi;
    end
end