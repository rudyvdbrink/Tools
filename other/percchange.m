function [y, mu] = percchange(x,dim)
%PERCCHANGE  Convert variable to percent change from mean.
%   
%   y = PERCCHANGE(x) subtracts the mean of variable x from the elements in
%   x, divides by the mean, and multiplies by 100.
%
%   [y, mu] = PERCCHANGE(x,dim) normalizes along dimension dim and returns 
%   the original mean mu. The default dimension that PERCCHANGE uses is
%   the first non-singleton dimension.
%
%   See also MEAN, DEMEAN.
%
%   Rudy van den Brink, 2012

%% Check the input

if nargin > 2
    error('Im sorry Dave, but I cant let you do that. Provide two inputs max.')
end

%% Remove mean

% [] is a special case for mean, just handle it out here.
if isequal(x,[]), y = x; return; end

if nargin < 2
    % figure out which dimension to work along.
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end

mu = mean(x,dim); %compute mean of x and 
y  = bsxfun(@minus, x, mu); %subtract the mean 
y  = bsxfun(@rdivide, y, mu); %divide by the mean
y  = bsxfun(@times, y, 100); %multiply by 100

end