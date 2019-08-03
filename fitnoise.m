function [rho, k] = fitnoise(lambda,varargin)
%   Fit noise distribution to eigenvalues and find the number of modes for
%   which the empirical eigenvalue distribution exceeds the noise
%   distribution. 
%
%   In this context, "noise" means randomly normally distributed with zero
%   mean. FITNOISE uses grid search for fitting by default.
%
%   This function implements the method proposed by Mitra and Pesaran
%   (1999) Analysis of Dynamic Brain Imaging Data. Bio Phys J (see 
%   equations 18 and 19) 
%   
%   For an example application, see also equations 8 and 9 in van den Brink 
%   Nieuwenhuis and Donner (2018) Amplification and Suppression of Distinct 
%   Brainwide Activity Patterns by Catecholamines. J Neurosci 38(34):7476-7491
%
%   Usage: 
%    [rho k] = fitnoise(lambda)
%    [rho k] = fitnoise(lambda,'grid',n,range)
%    [rho k] = fitnoise(lambda,'gradient',sv,maxiter)
%
%   Input (in case of grid search):
%    lambda:   square matrix with eigenvalues on its diagonal
%    n:        (optional) number of iterations for fitting (default: 20000)
%    range:    (optional) the range of scalars to fit across (default -1 to 1)
%
%   Input (in case of gradient descent):
%    lambda:   square matrix with eigenvalues on its diagonal
%    sv:       (optional) starting value for fitting (default: 1)
%    maxiter:  (optional) max iterations and max function evaluations
%
%   Output: 
%    rho:    the fitted noise distribution
%    k:      the number of modes for wich rho < lambda
%
%   Example:
%    a = rand(100); %generate random numbers
%    [~,s] = svd(a); %apply SVD to get eigenvalues
% 
%    figure
%    bar(diag(s)); %make a bar plot of the eigenvalues
%    %fit the noise distribution using gradient descent, with a starting
%    %value of 0, and a max of 1000 function evaluations
%    [rho, k] = fitnoise3(s,'gradient',0,1000); 
%    hold on
%    plot(rho,'r','linewidth',2) %plot the noise distribution
%    legend('Eigenvalues','\rho')
%
% RL van den Brink, 2018

%% check input

if nargin == 0
    error('not enough input arguments')
elseif nargin == 1
    method = 'grid';
    n     = 20000;
    range = linspace(-1,1,n);
elseif nargin > 1
    method = varargin{1};
end


if strcmpi(method,'grid') 
    if nargin == 2
        n     = 20000;
        range = linspace(-1,1,n);
    elseif nargin == 3
        n     = varargin{2};
        range = linspace(-1,1,n);
    elseif nargin == 4
        n     = varargin{2};
        range = varargin{3};
        range = linspace(range(1),range(2),n);
    elseif nargin > 4
        error('too many input arguments for method "grid"')
    end
elseif strcmpi(method,'gradient')
    if nargin == 2
        sv    = 1;
        n     = 20000;
    elseif nargin == 3
        sv    = varargin{2};
        n     = 20000;
    elseif nargin == 4
        sv    = varargin{2};
        n     = varargin{3};
    elseif nargin > 4
        error('too many input arguments for method "gradient"')        
    end  
    
    if isempty(sv); sv = 1; end
else
    error(['unrecognized fitting option "' method '"'])    
end

if isempty(n); n = 20000; end


%% define distribution

dat = diag(lambda);
sigma = std(dat);

p = size(lambda,1);
q = size(lambda,2);

lmin = (2*sigma^2) * ( (p+q)/2 - sqrt(p*q)) ;
lmax = (2*sigma^2) * ( (p+q)/2 + sqrt(p*q)) ;

rho = (1/pi * sigma .* dat) .* sqrt( (lmax - dat.^2) -  (dat - lmin) );

%% grid search fitting
if strcmpi(method,'grid')
    d = zeros(n,1);
    for ri = 1:n
        d(ri) = sum(dat-(rho*range(ri)));
    end
    [~, i] = min(d.^2);
    x = range(i);    
    if sum(x==[range(1) range(end)])        
        warning('fitting parameter on range bound, consider widening search grid')
    end    
    
%% gradient descent fitting
elseif strcmpi(method,'gradient')    
    options = optimset('MaxIter',n,'MaxFunEvals',n);  %  set Simplex options to perform rigorous search
    f = @(x) sum((dat-rho*x).^2);
    x = fminsearch(f,sv,options);    
end

%% find rho and k

rho = rho*x;
k = find(dat-rho > 0,1,'last');
if isempty(k); k = 0; end

