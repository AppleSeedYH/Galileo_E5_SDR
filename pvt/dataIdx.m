function idx = dataIdx(sat, data, code)
%DATA_IDX   Get observation data index for a given satellite and code
%
%   idx = data_idx(sat, data, code)
%
% Inputs:
%   sat   – integer satellite index (global 1-based)
%   data  – struct with field .code (1×(NFREQ+NEXOBS) vector)
%   code  – numeric observation code constant
%
% Outputs:
%   idx   – index into data.code where to store this code (1-based), or -1 if full

    % Determine GNSS system from satellite index
    % satsys should return a NavSysConstants flag and optionally PRN
    sys = satsys(sat);
    % Get primary slot from code and system
    idx = code2idx(sys, code);

    % If primary slot is free, return it
    if data.code(idx) == 0
        return;
    end

    % Otherwise search extended slots (NFREQ+1 to NFREQ+NEXOBS)
    for i = NFREQ+1 : NFREQ+NEXOBS
        if data.code(i) == 0
            idx = i;
            return;
        end
    end

    % No free slot found
    idx = -1;
end
