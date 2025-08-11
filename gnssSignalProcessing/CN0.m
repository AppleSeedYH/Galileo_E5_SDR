function ch = CN0(ch)

ch.trk.sumP = ch.trk.sumP + abs(ch.trk.C(1))^2;  % Update sumP with the power of C[0]
ch.trk.sumN = ch.trk.sumN + abs(ch.trk.C(4))^2;  % Update sumN with the power of C[3]

if mod(ch.lockCount, floor(ch.config.T_CN0 / ch.tCodeCyc)) == 0
    if ch.trk.sumN > 0.0
        cn0 = 10.0 * log10(ch.trk.sumP / ch.trk.sumN / ch.tCodeCyc);  % Calculate C/N0
        ch.cn0 = ch.cn0 + 0.5 * (cn0 - ch.cn0);  % Update cn0 with smoothing
    end
    ch.trk.sumP = 0.0;  % Reset sumP
    ch.trk.sumN = 0.0;  % Reset sumN
end
