function v = linmap(v,oldrange,newrange)
%LINMAP  Linearly scale one range vector onto another range.
%   
%   v = LINMAP(v,oldrange,newrange) linearly stretches vector range such
%   that its min becomes newrange(1) and its max becomes newrange(2). Input
%   range should be a single row or column vector, and input newrange
%   should be a single row or column vector of length 2. Oldrange should
%   also be a single row or column vector of length 2 and specifies the min
%   and max values in v that are mapped onto the newrange. Values in v
%   outside of oldrange get set to the min or max. 
%
%   See also MIN MAX
%
%   RL van den Brink, 2015

%linearly compress / stretch values to the new range
v  = ( (v - oldrange(1)) ./ (oldrange(2) - oldrange(1)) ) * (newrange(end) - newrange(1)) + newrange(1);
%set values that are outside of the new range to the min and max
v(v < newrange(1)) = newrange(1);
v(v > newrange(2)) = newrange(2);
