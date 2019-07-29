function y = demean(x)
%DEMEAN  De-mean a signal.
%   
%   y = DEMEAN(x) subtracts the mean of signal x from each time-point in x.
%   Input should be a vector which can be either a row or a column vector.
%
%   See also MEAN
%
%   Rudy van den Brink, 2012

%% Check the input

if nargin ~= 1
    error('Im sorry Dave, but I cant let you do that. You need just one input argument')
end

if length(size(x)) > 2
    error('Input should be a vector')
end

%% De-mean

if size(x,2) >= size(x,1) %row vector
    if size(x,1) ~= 1; error('Input should be a single row or column'); end
    y = x - repmat(mean(x),1,length(x));
elseif size(x,2) <= size(x,1) %column vector
    if size(x,2) ~= 1; error('Input should be a single row or column'); end
    y = x - repmat(mean(x),length(x),1);
end


end