function sol = corr_sol_time(sol)
%CORR_SOL_TIME   Correct solution time using alternate system clock biases
%
%   sol = corr_sol_time(sol)
%
% If the primary clock bias (dtr(1)) is near zero, use the first non-zero
% alternate system bias (dtr(2:5)) to adjust the solution time and bias.

    % If GPS bias is valid, do nothing
    if abs(sol.dtr(1)) >= 1e-9
        return;
    end

    % Search for GLO, GAL, BDS, IRN biases
    for i = 2:5
        if abs(sol.dtr(i)) >= 1e-9
            % Use this alternative bias
            sol.dtr(1) = sol.dtr(i);
            sol.time = sol.time + sol.dtr(1);
            return;
        end
    end
end
