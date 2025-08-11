function [x, info, Q] = lsq(A, y, n)
%LSQ   Solve weighted least-squares by normal equations
%
%   [x, info, Q] = lsq(A, y, n)
%
% Inputs:
%   A    – n×m matrix (design matrix)
%   y    – m×1 vector (observations)
%   n    – number of unknowns (rows of A)
%
% Outputs:
%   x    – n×1 solution vector
%   info – status flag (0 = success, nonzero = failure)
%   Q    – n×n normal matrix A*A'

    % Compute A*y
    Ay = A' * y;
    % Compute normal matrix Q = A*A'
    Q = A' * A;
    % Initialize
    x = zeros(n,1);
    info = 0;
    % Attempt inversion and solve x = Q^-1 * Ay
    try
        x = Q \ Ay;
    catch
        % Singular or ill-conditioned
        info = 1;
    end
end