function h = mfdr(p,varargin)
% MFDR corrects symmetric matrix p for multiple comparisons using the 
% false discovery rate at threshold q. This function requires that matrix p 
% is symmetric around the diagonal (i.e. p equals p'). This function is 
% intended to only correct for comparisons across unique test elements of
% p. 
%
%   Usage:
%     h = mfdr(p)
%     h = mfdr(p, q, k)
%
%   Input:
%     p:          square and symmetric matrix p: values should range
%                 between 0 and 1
%     q:          (optional) q value threshold (default: 0.05)
%     k:          (optional) take the elements on and above the K-th 
%                 diagonal of X.  K = 0 is the main diagonal, K > 0 is 
%                 above the main diagonal and K < 0 is below the main 
%                 diagonal (default: 0);
%
%   Output:
%     h:          significance (1 or 0)
%  
% This implements
%  Genovese CR, Lazar NA, Nichols T.
%  Thresholding of statistical maps in functional neuroimaging using the 
%  false discovery rate. Neuroimage. 2002 Apr;15(4):870-8.
%
%     See also TRIUV, FDR.
%
% RL van den Brink, 2019


%% check input
if nargin == 0
    error('not enough input arguments')
elseif nargin == 1
    q = 0.05;
    k = 0;
elseif nargin == 2
    q = varargin{1};
    k = 0;
elseif nargin == 3
    q = varargin{1};
    k = varargin{2};
else
    error('too many input arguments')
end

if ~issymmetric(p)
    error('p is not symmetric')
end

if min(p(:)) < 0 || max(p(:)) > 1
    error('values in p should range between 0 and 1')
end

if isempty(q)
    q = 0.05;
end

if isempty(k)
    k = 0;
end
    
%% correct
h = zeros(size(p));
[b, ind] = triuv(p,k);
h2 = fdr(b,q);
h(ind) = logical(h2);
h = logical(h+h');

end

%% supporting functions

function [V, ind, c] = triuv(M,k)
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
    
ind = find(triu(ones(size(M,1)),k)==1);
V = M(ind);
[I, J] = ind2sub(size(M),ind);
c = [I J];
end


function [h, pi] = fdr(p, q)

% FDR false discovery rate
%
% Use as
%   h = fdr(p, q)
%
% This implements
%   Genovese CR, Lazar NA, Nichols T.
%   Thresholding of statistical maps in functional neuroimaging using the false discovery rate.
%   Neuroimage. 2002 Apr;15(4):870-8.

% convert the input into a row vector
dim = size(p);
p = reshape(p, 1, numel(p));

% sort the observed uncorrected probabilities
[ps, indx] = sort(p);

% count the number of voxels
V = length(p);

% compute the threshold probability for each voxel
pi = ((1:V)/V)  * q / c(V);

h = (ps<=pi);

% undo the sorting
[~, unsort] = sort(indx);
h = h(unsort);

% convert the output back into the original format
h = reshape(h, dim);
end

function s = c(V)
% See Genovese, Lazar and Holmes (2002) page 872, second column, first paragraph
if V<1000
  % compute it exactly
  s = sum(1./(1:V));
else
  % approximate it
  s = log(V) + 0.57721566490153286060651209008240243104215933593992359880576723488486772677766467093694706329174674951463144724980708248096050401448654283622417399764492353625350033374293733773767394279259525824709491600873520394816567;
end
end