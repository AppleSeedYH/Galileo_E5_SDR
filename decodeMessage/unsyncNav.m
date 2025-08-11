function ch = unsyncNav(ch)
%UNSYNC_NAV   Clear navigation sync and reset timing state
%
%   ch = unsync_nav(ch)
%
% Inputs:
%   ch.nav.fsync, ch.nav.ssync, ch.nav.rev – frame and subframe sync flags
%   ch.nav.coff  – carrier‐phase offset
%   ch.tow       – time‐of‐week (ms)
%   ch.tow_v     – time‐of‐week validity flag
%
% Outputs:
%   ch           – with all above fields reset

    % clear sync indicators
    ch.nav.fsync = 0;
    ch.nav.ssync = 0;
    ch.nav.rev   = 0;
    
    % reset carrier‐phase offset
    ch.nav.coff  = 0.0;
    
    % invalidate time‐of‐week
    ch.tow       = -1;
    ch.tow_v     = 0;
end
