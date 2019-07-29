function y = percchange(x)
%PERCCHANGE  Convert vector to percent change from mean.
%   
%   y = PERCCHANGE(x) subtracts the mean of signal x from each time-point
%   in x, then divides by the mean of x, and multiplies by 100.
%   Input should be a two dimensional vector which can be either a row or a
%   column vector.
%
%   See also MEAN
%
%   Rudy van den Brink, 2019

%% Check the input

if nargin ~= 1
    error('Im sorry Dave, but I cant let you do that. You need just one input argument')
end

if length(size(x)) > 2
    error('Input should be a two dimensional vector')
end

%% Convert to percent change

m = mean(x);
y = ((x-m)/m)*100;


end