function code = sig2code(sig)
%SIG2Const.CODE   Map signal identifier string to numeric code constant
%
%   code = sig2code(sig)
%
% Input:
%   sig  – character vector (e.g. 'L1CA', 'E5BI', etc.)
%
% Output:
%   code – uint8 code constant corresponding to signal, or 0 if unrecognized

    switch sig
        case 'L1CA'
            code = Const.CODE_L1C;
        case 'L1S'
            code = Const.CODE_L1Z;
        case 'L1CB'
            code = Const.CODE_L1E;
        case 'L1CP'
            code = Const.CODE_L1L;
        case 'L1CD'
            code = Const.CODE_L1S;
        case 'L2CM'
            code = Const.CODE_L2S;
        case 'L2CL'
            code = Const.CODE_L2L;
        case 'L5I'
            code = Const.CODE_L5I;
        case 'L5Q'
            code = Const.CODE_L5Q;
        case 'L5SI'
            code = Const.CODE_L5D;
        case 'L5SQ'
            code = Const.CODE_L5P;
        case 'L5SIV'
            code = Const.CODE_L5D;
        case 'L5SQV'
            code = Const.CODE_L5P;
        case 'L6D'
            code = Const.CODE_L6S;
        case 'L6E'
            code = Const.CODE_L6E;
        case 'G1CA'
            code = Const.CODE_L1C;
        case 'G2CA'
            code = Const.CODE_L2C;
        case 'G1OCD'
            code = Const.CODE_L4A;
        case 'G1OCP'
            code = Const.CODE_L4B;
        case 'G2OCP'
            code = Const.CODE_L6B;
        case 'G3OCD'
            code = Const.CODE_L3I;
        case 'G3OCP'
            code = Const.CODE_L3Q;
        case 'E1B'
            code = Const.CODE_L1B;
        case 'E1C'
            code = Const.CODE_L1C;
        case 'E5AI'
            code = Const.CODE_L5I;
        case 'E5AQ'
            code = Const.CODE_L5Q;
        case 'E5BI'
            code = Const.CODE_L7I;
        case 'E5BQ'
            code = Const.CODE_L7Q;
        case 'E6B'
            code = Const.CODE_L6B;
        case 'E6C'
            code = Const.CODE_L6C;
        case 'B1I'
            code = Const.CODE_L2I;
        case 'B1CD'
            code = Const.CODE_L1D;
        case 'B1CP'
            code = Const.CODE_L1P;
        case 'B2I'
            code = Const.CODE_L7I;
        case 'B2AD'
            code = Const.CODE_L5D;
        case 'B2AP'
            code = Const.CODE_L5P;
        case 'B2BI'
            code = Const.CODE_L7D;
        case 'B3I'
            code = Const.CODE_L6I;
        case 'I1SD'
            code = Const.CODE_L1D;
        case 'I1SP'
            code = Const.CODE_L1P;
        case 'I5S'
            code = Const.CODE_L5A;
        case 'ISS'
            code = Const.CODE_L9A;
        otherwise
            code = 0;
    end
end
