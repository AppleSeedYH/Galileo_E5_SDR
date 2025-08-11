function status = syncFrame(ch, preamb, syms)
%SYNC_FRAME  Check for frame sync by looking for preamble at both ends.
%   status = SYNC_FRAME(ch, preamb, bits) returns
%      0 if preamble found normally at start & end,
%      1 if reversed (no matches at either end),
%     -1 otherwise.

    N = numel(preamb);

    % check for normal sync: both head and tail match preamble
    if isequal(syms(1:N),             preamb) && ...
       isequal(syms(end-N+1:end),     preamb)
        disp('Frame synced');
        status = 0;
        return;
    end

    % check for reversed: neither head nor tail matches at all
    if all(syms(1:N)     ~= preamb) && ...
       all(syms(end-N+1:end) ~= preamb)
        status = 1;
        disp('Frame synced');
        return;
    end

    % no clear sync
    status = -1;
end