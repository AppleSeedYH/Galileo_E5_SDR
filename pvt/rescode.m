function [v, H, varW, nv] = rescode(iter, obs, rs, dts, vare, svh, nav, x, opt)
%RESCODE   Compute pseudorange residuals and design matrix for positioning
%
% Inputs:
%   iter  – current iteration number (integer)
%   obs   – 1×n observation struct with fields .time, .sat, .P, .code, .SNR
%   rs    – 6×n satellite state matrix [pos; vel]
%   dts   – 2×n satellite clock bias matrix
%   vare  – 1×n pseudorange variance from ephemeris
%   svh   – 1×n satellite health flags
%   nav   – navigation data struct
%   x     – Const.NX×1 solution vector [X;Y;Z;dtr;dtg;dtl;...]
%   opt   – options struct with fields elmin, ionoopt, tropopt
%   v     – (preallocated) residual vector
%   H     – (preallocated) design matrix Const.NX×? 
%   varW  – (preallocated) variance vector for weights
%   azel  – 2×n array to fill azimuth/elevation angles
%   vsat  – 1×n array to fill valid-satellite flags
%   resp  – 1×n array to fill pseudorange residuals
%
% Outputs:
%   nv    – number of valid pseudorange equations
%   ns    – number of valid satellites used

    % Const.NX     = 4;      % number of unknowns
    n_obs  = obs.n;     % number of observations
    rr     = x(1:3);         % receiver ECEF position
    dtr    = x(4);           % receiver clock bias
    ns     = 0;
    nv     = 0;
    mask   = false(Const.NX-3,1);

    v      = zeros(n_obs,1);
    H      = zeros(n_obs,Const.NX);
    varW   = zeros(n_obs,1);


    for i = 1:n_obs
        % vsat(i)     = 0;
        % azel(:,i)  = [0;0];
        % resp(i)    = 0;
        time     = obs.data(i).time;
        sat        = obs.data(i).sat;
        sys        = satsys(sat);

        % exclude satellite by health
        if (svh(i))
            disp('unhealthy satellites');
            continue;
        end

        % geometric distance and LOS vector
        [r, e] = geodist(rs(i,1:3)', rr);
        if r <= 0
            continue;
        end
        dion = 0; vion = 0; dtrp = 0; vtrp = 0;
        if iter > 1
            % pos    = ecef2pos(rr');   % convert to lat/lon/height (rad and m)
            % elevation mask
            % azel_val = satazel(pos, e);
            % if azel_val(2) < opt.elmin
            %     continue;
            % end
            % SNR mask
            % if ~snrmask(obs(i), azel_val, opt)
            %     continue;
            % end
            % iono correction
            % [ok, dion, vion] = ionocorr(time, nav, pos, azel_val);
            % if ~ok, continue; end
            % freq = sat2freq(sat, obs(i).code(1), nav);
            % if freq == 0, continue; end
            % dion = dion * (FREQ1/freq)^2;
            % vion = vion * (FREQ1/freq)^2;
            % tropo correction
            % [ok, dtrp, vtrp] = tropcorr(time, pos, azel_val);
            % if ~ok, continue; end
        else
            azel(:,i) = [0;0];
        end
        % pseudorange measurement
        P=obs.data(i).P(1);
        vmeas=Const.ERR_CBIAS;
        % [P, vmeas] = prange(obs(i), nav, opt);
        if P == 0, continue; end
        % residual
        % vsys = v( nv+1 ); %#ok<NASGU>
        v(nv+1,1) = P - (r + dtr - Const.CLIGHT*dts(i,1) + dion + dtrp);
        % design
        H(nv+1, 1:3) = -e;
        H(nv+1, 4)   = 1;
        varW(nv+1,1)=vare(i) + vmeas + vion + vtrp;
        % varW(nv+1,1)   = varerr(opt, azel(2,i), sys) + vare(i) + vmeas + vion + vtrp;
        % time offsets
        % switch sys
        %     case Const.SYS_GLO
        %         v(nv+1,1) = v(nv+1,1) - x(5);
        %         H(nv+1,5) = 1;
        %         mask(1) = true;
        %     case Const.SYS_GAL
        %         v(nv+1,1) = v(nv+1,1) - x(6);
        %         H(nv+1,6) = 1;
        %         mask(2) = true;
        %     case Const.SYS_CMP
        %         v(nv+1,1) = v(nv+1,1) - x(7);
        %         H(nv+1,7) = 1;
        %         mask(3) = true;
        %     case Const.SYS_IRN
        %         v(nv+1,1) = v(nv+1,1) - x(8);
        %         H(nv+1,8) = 1;
        %         mask(4) = true;
        %     otherwise
        %         % mask(0+1) = true;
        % end
        % vsat(i) = 1;
        % resp(i) = v(nv+1,1);
        ns = ns + 1;
        nv = nv + 1;
    end
    % add constraints for unused offsets
    % for k = 1:(Const.NX-3)
    %     if mask(k)
    %         continue;
    %     else
    %         v(nv+1,1) = 0;
    %         H(nv+1,4+k) = 1;% 3 or 4
    %         varW(nv+1,1) = 0.01;
    %         nv = nv + 1;
    %     end
    % end
end