function lla = ecef2pos(ecefXYZ)
    lla = ecef2lla(ecefXYZ, 'WGS84');  % returns [deg deg m]
    lla(:,1) = deg2rad(lla(:,1));
    lla(:,2) = deg2rad(lla(:,2));
    % h   = lla(:,3);
end