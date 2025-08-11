function [secCode]= genSecCode(sig,prn)
load(".\signalGeneration\Galileo\CS.mat");
sig=upper(sig);
switch sig
    case 'L1CA'
        secCode = 1;
    case 'E5AI'
        secCode = readCodeHex(CS20,20);
    case 'E5AQ'
        secCode = readCodeHex(CS100(prn),100);
    case 'E5BI'
        secCode = readCodeHex(CS4,4);
    case 'E5BQ'
        secCode = readCodeHex(CS100(prn+50),100);
end