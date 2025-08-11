%  Generate resampled and zero-padded code.
%
%  args:
%      code     (I) Code as int8 ndarray (-1 or 1)
%      T        (I) Code cycle (period) (s)
%      coff     (I) Code offset (s)
%      fs       (I) Sampling frequency (Hz)
%      N        (I) Number of samples
%      Nz=0     (I) Number of zero-padding (optional)
%
%  returns:
%      code     Resampled and zero-padded code as complex64 ndarray (-1 or 1)
function code_resampled = resCode(code, T, coff, fs, N, Nz)
    if nargin < 6
        Nz = 0;  % Default value for Nz if not provided
    end

    % Calculate dx and the indices
    dx = length(code) / T / fs;
    ix = floor((coff * fs + (0:N-1)) * dx) + 1; % +1 for 1-based indexing
    
    % Set all zeros in ix to ones (should consider more about it)
    %ix(ix==0)=1;

    % Extract the resampled code using modulo operation
    code_resampled = complex(code(mod(ix - 1, length(code)) + 1), 0); % Ensure complex type

    % Add zero padding if Nz > 0
    if Nz > 0
        code_resampled = [code_resampled, zeros(1, Nz, 'like', code_resampled)];
    end
end