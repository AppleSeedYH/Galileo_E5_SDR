function nav = navNew()
    % Create a new navigation structure
    nav = struct();
    
    % Initialize fields in the nav structure
    nav.ssync = 0;       % symbol sync time as lock count (0: no-sync)
    nav.fsync = 0;       % nav frame sync time as lock count (0: no-sync)
    nav.rev = 0;         % code polarity (0: normal, 1: reversed)
    nav.seq = 0;         % sequence number (TOW, TOI, ...)
    nav.nerr = 0;        % number of error corrected
    nav.type = 0;        
    nav.stat = 0;
    nav.coff = 0;  % code offset for L6D/E CSK
    nav.syms = zeros(1, 18000); % nav symbols buffer
    nav.tsyms = zeros(1, 18000); % nav symbols time (for debug)
    nav.data = cell(10,1);       % navigation data buffer
    nav.count = [0, 0];  % navigation data count (OK, error)
    %nav.opt = nav_opt;   % navigation option string
    
end
