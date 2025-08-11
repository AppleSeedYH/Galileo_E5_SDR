function ch = navDecode(ch)
%SDR_NAV_DECODE   Decode one raw navigation message based on its signal type
%
% Inputs:
%   ch       – struct with at least the field
%                .sig   (string indicating signal, e.g. 'L1CA','E5BQ', etc.)
%
% Outputs:
%   ch       – same struct, potentially modified by the decode_* functions

    switch ch.sig
        case 'L1CA'
            ch = decode_L1CA(ch);
        case 'E1B'
            ch = decode_E1B(ch);
        case 'E1C'
            ch = decode_E1C(ch);
        case 'E5AI'
            ch = decode_E5AI(ch);
        case 'E5AQ'
            ch = decode_E5AQ(ch);
        case 'E5BI'
            ch = decode_E5BI(ch);
        case 'E5BQ'
            ch = decode_E5BQ(ch);
        case 'E6B'
            ch = decode_E6B(ch);
        case 'E6C'
            ch = decode_E6C(ch);
        otherwise
            % unknown or unsupported signal: do nothing
    end
end
