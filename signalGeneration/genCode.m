function [code]= genCode(sig,prn)
load(".\signalGeneration\Galileo\E5X1X2.mat");
sig=upper(sig);
switch sig
    case 'L1CA'
        code = genCodeL1CA(prn);
    case 'E5AI'
        code = genCodeE5AI(prn,E5AI_X2_init);
    case 'E5AQ'
        code = genCodeE5AQ(prn,E5AQ_X2_init);
    case 'E5BI'
        code = genCodeE5BI(prn,E5BI_X2_init);
    case 'E5BQ'
        code = genCodeE5BQ(prn,E5BQ_X2_init);
    case 'L1CA'
        code = genCodeL1CA(prn);
end