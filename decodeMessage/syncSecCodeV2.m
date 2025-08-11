function [ch,isSynced] = syncSecCodeV2(ch)
    % sync_sec_code: Sync secondary code
    % Args:
    %   ch: Channel structure containing sec_code, trk, and lock fields
    % Returns:
    %   isSynced: Boolean indicating if synchronization occurred
    
    N = length(ch.secCode); % Length of the secondary code

    if N < 2 || ch.trk.secSync == 0 || mod(ch.lockCount - ch.trk.secSync, N) ~= 0
        isSynced = false; % Return false if conditions for sync are not met
    else
        % Add to the navigation symbols buffer
        polarity=double(dot(ch.secCode,real(ch.trk.P(end-N+1:end)))/N>= 0.0);
        % polarity = double(mean(real(ch.trk.P(end-N+1:end))) >= 0.0);
        ch.nav.syms=addBuff(ch.nav.syms, polarity); % Update buffer with polarity
        isSynced = true; % Synchronization successful
    end
end
