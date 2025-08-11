function navDecode(ch)
    switch ch.sig
        case 'L1CA'
            decode_L1CA(ch);
        case 'L1S'
            decode_L1S(ch);
        case 'L1CB'
            decode_L1CB(ch);
        case 'L1CD'
            decode_L1CD(ch);
        case 'L2CM'
            decode_L2CM(ch);
        case 'L5I'
            decode_L5I(ch);
        case 'L6D'
            decode_L6D(ch);
        case 'L6E'
            decode_L6E(ch);
        case 'L5SI'
            decode_L5SI(ch);
        case 'L5SIV'
            decode_L5SIV(ch);
        case 'G1CA'
            decode_G1CA(ch);
        case 'G2CA'
            decode_G2CA(ch);
        case 'G1OCD'
            decode_G1OCD(ch);
        case 'G3OCD'
            decode_G3OCD(ch);
        case 'E1B'
            decode_E1B(ch);
        case 'E5AI'
            decode_E5AI(ch);
        case 'E5BI'
            decode_E5BI(ch);
        case 'E6B'
            decode_E6B(ch);
        case 'B1I'
            decode_B1I(ch);
        case 'B1CD'
            decode_B1CD(ch);
        case 'B2I'
            decode_B2I(ch);
        case 'B2AD'
            decode_B2AD(ch);
        case 'B2BI'
            decode_B2BI(ch);
        case 'B3I'
            decode_B3I(ch);
        case 'I1SD'
            decode_I1SD(ch);
        case 'I5S'
            decode_I5S(ch);
        case 'ISS'
            decode_ISS(ch);
        otherwise
            return;
    end
end
