function [V, ind, c] = triuv(M,K)
% TRIUV extracts the upper triangular part of a square matrix, vectorized.
%     triu(M) is the upper triangular part of M vectorized.
%     triu(M,K) is the elements on and above the K-th diagonal of
%     M.  K = 0 is the main diagonal, K > 0 is above the main
%     diagonal and K < 0 is below the main diagonal.
%
%     Output arguments can be:
%       V: the vectorized triangular
%       ind: the indices corresponding to elements in V
%       c: the coordinates in M corresponding to elements in V
%  
%     See also TRIU, DIAG.
    
if ~exist('K','var')
    K = 0;
end

ind = find(triu(ones(size(M,1)),K)==1);
V = M(ind);
[I, J] = ind2sub(size(M),ind);
c = [I J];

end