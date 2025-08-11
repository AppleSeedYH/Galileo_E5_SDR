function [ok, dts] = ephclk(time, sat, nav)
%EPHCLK   Satellite clock bias using broadcast ephemeris
%
%   [ok, dts] = ephclk(time, teph, sat, nav)
%
% Inputs:
%   time – gtime struct (fields .time, .sec)
%   teph – transmission epoch for ephemeris (gtime struct)
%   sat  – global satellite index
%   nav  – navigation data struct containing ephemeris fields
%
% Outputs:
%   ok   – logical true if clock computed successfully
%   dts  – clock bias (s)

    % Initialize
    ok = false;
    dts = 0;

    % Determine system
    [sys, ~] = satsys(sat);

    switch sys
        case {Const.SYS_GPS, Const.SYS_GAL, ...
              Const.SYS_QZS, Const.SYS_CMP, Const.SYS_IRN}
            
            % Broadcast ephemeris
            % eph = seleph(teph, sat, -1, nav);
            if isempty(nav.eph(sat))
                return;
            end
            dts = eph2clk(time, nav.eph(sat));
        
            % the following comments to be done
        % case Const.SYS_GLO
        %     geph = selgeph(teph, sat, -1, nav);
        %     if isempty(geph)
        %         return;
        %     end
        %     dts = geph2clk(time, geph);
        % 
        % case Const.SYS_SBS
        %     seph = selseph(teph, sat, nav);
        %     if isempty(seph)
        %         return;
        %     end
        %     dts = seph2clk(time, seph);

        otherwise
            return;
    end

    ok = true;
end