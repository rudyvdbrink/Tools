function [Mz, ind] = module_arrange(M,modz,ind)
% MODULE_ARRANGE re-arranges a matrix to reflect community structure 
%
%   Usage:  [Mz ind] = module_arrange(M,modz)
%           [Mz ind] = module_arrange(M,[],ind)
%
%   Input:  M, directed/undirected weighted/binary connection matrix (must
%              be square).
%           modz, vector of length size(M,1) containing labels of modules.
%           ind (optional), vector of length size(M,1) containing indices 
%              of the re-arranged matrix of the original matrix. If ind is
%              supplied as input, modz will be ignored and the matrix will
%              be re-arranged back to its original form.
%
%   Output: Mz, re-arranged connection matrix to reflect community
%              structure
%           ind, vector of length size(M,1) containing the original indices 
%              of the re-arranged matrix 
%
% RL van den Brink, 2019

if nargin < 2
    help modularize;
    return
elseif nargin == 2
    arrange_back = 0;    
    if length(modz) ~= size(M,1)
        error('modz should have the same length as M)');
    elseif  size(M,1) ~= size(M,2)
        error('M must be square');
    end
elseif nargin == 3 && ~isempty(ind)
    arrange_back = 1;
    if ~isempty(modz) && ~isempty(ind)
        warning('input indices detected, modz will be ignored')
    end    
    if length(ind) ~= size(M,1)
        error('mind should have the same length as M)');
    end
end

%% Re-arrange the matrix

%formatting by module
if ~arrange_back
    [~,ind] = sort(modz); %sort by module
%formatting back to original form
else
    [~,ind] = sort(ind); %sort by index
end

%arrange by indices
Mz = M(ind,ind); 

end
