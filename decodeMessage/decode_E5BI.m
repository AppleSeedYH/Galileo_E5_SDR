function ch = decode_E5BI(ch)
%DECODE_E5BI   Decode Galileo E5BI navigation bits
%
%   ch = decode_E5BI(ch)
%
% Inputs:
%   ch.nav.syms       – vector of symbols (length SDR_MAX_NSYM)
%   ch.nav.fsync      – frame‐sync index (>0 when synced)
%   ch.nav.rev        – current revision/page index
%   ch.len_sec_code   – length (in symbols) of the secondary code
%   ch.lock           – current code lock count
%
% Outputs:
%   ch                – updated channel struct

    % Galileo I/NAV preamble pattern
    preamb = [0 1 0 1 1 0 0 0 0 0];

    % first, sync secondary code or bail
    [ch,isSynced]=syncSecCodeV2(ch);
    if ~isSynced
        return;
    end

    % grab the last 510 symbols
    nsym = numel(ch.nav.syms);
    syms = ch.nav.syms(nsym-509 : nsym);

    if ch.nav.fsync > 0
        % already frame‐synced
        if ch.lockCount == ch.nav.fsync + 2000
            rev = syncFrame(ch, preamb, syms);
            if rev == ch.nav.rev
                ch = decodeGalInavPage(ch, syms, rev);
            end
        elseif ch.lockCount > ch.nav.fsync + 2000
            ch = unsyncNav(ch);
        end

    elseif ch.lockCount >= length(ch.secCode)*510 + 250
        % haven’t synced a frame yet, but enough bits to try
        rev = syncFrame(ch, preamb, syms);
        if rev >= 0
            ch = decodeGalInavPage(ch, syms, rev);
        end
    end
end
