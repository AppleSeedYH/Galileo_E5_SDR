function [stat, sol] = estpos(obs, rs, dts, vare, svh, nav, opt, sol)
%ESTPOS   Estimate receiver position by iterative least‐squares
%
%   [stat, sol] = estpos(obs, rs, dts, vare, svh, nav, opt, sol, azel, vsat, resp, msg)
%
% Inputs:
%   obs   – 1×n observation struct array
%   rs    – 6×n satellite states [pos;vel]
%   dts   – 2×n satellite clock biases/drifts
%   vare  – 1×n pseudorange variances
%   svh   – 1×n satellite health flags
%   nav   – navigation data struct
%   opt   – processing options struct
%   sol   – input solution struct (sol.rr used as start)
%   azel  – 2×n array for az/el (output)
%   vsat  – 1×n visibility flags (output)
%   resp  – 1×n residuals (output)
%   msg   – char buffer for status message (output)
%
% Outputs:
%   stat  – logical success flag
%   sol   – updated solution struct (position, clock, covariance, status)

    % Const.NX    = 4;                   % number of unknowns (X,Y,Z + clock + offsets)

    % initialize solution vector x = [X;Y;Z;dtr;...offsets]
    x  = zeros(Const.NX,1);
    % dx = zeros(Const.NX,1);
    % Q  = zeros(Const.NX,Const.NX);

    % start from previous solution positions
    x(1:3) = sol.rr(1:3);

    % allocate residuals v, design H, weight varW
    % n    = obs.n;
    % v    = zeros(n+4,1);
    % H    = zeros(Const.NX, n+4);
    % varW = zeros(n+4,1);

    stat = false;
    for iter = 1:Const.MAXITR
        % compute pseudorange residuals, design, sigma2, azel, vsat, resp
        [v, H, varW, nv]= rescode(iter, obs, rs, dts, vare, svh, nav, x, opt);
        % [nv, ns] = rescode(iter, obs, rs, dts, vare, svh, nav, x, opt, ...
        %                    v, H, varW, azel, vsat, resp);

        if nv < Const.NX
            disp('lack of valid sats ns=%d', nv);
            return;
        end

        % weight by 1/std deviation
        % W =  sqrt(varW(1:nv));
        % v(1:nv)    = v(1:nv) ./ W;
        % for k = 1:Const.NX
        %     H(k,1:nv) = H(k,1:nv) ./ W;
        % end

        % solve normal equations H*dx = v
        [dx, info, Q] = lsq(H(1:nv,:), v(1:nv,:), Const.NX);
        if info ~= 0
            msg = sprintf('lsq error info=%d', info);
            return;
        end

        x = x + dx;
        if norm(dx) < 1e-4
            % converged
            % fill solution
            sol.type = 0;  % XYZ‐ECEF
            sol.time = obs.data(1).time - x(4)/Const.CLIGHT;
            sol.dtr(1) = x(4)/Const.CLIGHT;
            % zero out inter‐system offsets
            % sol.dtr(2:5) = x(5:8)/Const.CLIGHT;
            sol.rr(1:3)  = x(1:3);
            sol.rr(4:6)  = 0;
            % covariance: first 3×3 and off‐diagonals
            sol.qr(1) = Q(1,1); sol.qr(2) = Q(2,2); sol.qr(3) = Q(3,3);
            sol.qr(4) = Q(1,2); sol.qr(5) = Q(2,3); sol.qr(6) = Q(3,1);
            % sol.ns    = ns;
            % sol.age   = 0;
            % sol.ratio = 0;

            % Validate with RAIM or other checks
            % if valsol(azel, vsat, n, opt, v, nv, Const.NX, msg)
            %     sol.stat = (opt.sateph==EPHOPT_SBAS) * SOLQ_SBAS + ...
            %                (opt.sateph~=EPHOPT_SBAS) * SOLQ_SINGLE;
            %     stat = true;
            % end
            lla = ecef2lla(x(1:3)');
            fprintf('\nLS position is [%.2f %.2f %.2f]\n', lla);
            stat = true;
            return;
        end
    end
end
