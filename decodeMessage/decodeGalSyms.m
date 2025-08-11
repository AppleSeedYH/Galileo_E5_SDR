function bits = decodeGalSyms(syms, ncol, nrow)
%DECODE_GAL_SYMS   Block‐deinterleave and rate-1/2 decode Galileo symbols
%
%   bits = decode_gal_syms(syms, ncol, nrow)
%
% Inputs:
%   syms   – column vector of uint8 symbols (length ncol*nrow)
%   ncol   – number of columns in the interleaving matrix
%   nrow   – number of rows in the interleaving matrix
%
% Output:
%   bits   – uint8 vector of decoded bits (length == half of ncol*nrow)

    % preallocate buffer for de-interleaved, inverted symbols
    
    % Convert CNAV-producing convolutional code polynomials to trellis description
    % Note that the difference from GPS is that the second branch G2 is
    % inverted at the end (see ICD)
    trellis = poly2trellis(7,[171 ~133]);

    % Viterbi traceback depth for vitdec(function)
    tblen = 35;

    % De-interleave symbols
    symMat1 = reshape(syms,ncol,nrow)';
    pageSym1 = reshape(symMat1,1,[])';

    % Remove convolutional encoding from implied pages
    decBits = vitdec(pageSym1,trellis,tblen,'trunc','hard');

    % Remove tail bits
    bits = decBits(1:114);

end
