function M = module_mean(M,modz,varargin)
%usage: M = module_mean(M,modz,collapse,incldiag)


%% Check input

if isempty(varargin) 
    collapse = 0;
    incldiag = 0;
else    
    if nargin < 2
        error('not enough input arguments')    
    elseif nargin == 3
        collapse = varargin{1};
        incldiag = 0;
    elseif nargin == 4
        collapse = varargin{1};
        incldiag = varargin{2};
    elseif nargin > 4
        error('too many input arguments')
    end
end

if size(M,1) ~= size(M,2)
    error('input matrix M must be square')
end

if length(modz) ~= size(M,1) || ~isvector(modz)
    error('input modz must be a vector and same length as input matrix M')
end

%% Compute module mean

if ~incldiag
    M(logical(eye(size(M)))) = NaN; %set diagonal to NaN so that we exclude it from the mean
end

%find borders between the modules
intersections = find(diff(modz));
intersections = [0 intersections length(modz)];

%compute the average value per module-module elements
if collapse
    Mz = zeros(length(intersections)-1);    
    for mi = 1:length(intersections)-1
        for mj = 1:length(intersections)-1
            Mz(mi,mj) = mean(nanmean(M(intersections(mi)+1:intersections(mi+1),intersections(mj)+1:intersections(mj+1))));
        end
    end    
else
    Mz = M;
    for mi = 1:length(intersections)-1
        for mj = 1:length(intersections)-1
            Mz(intersections(mi)+1:intersections(mi+1),intersections(mj)+1:intersections(mj+1)) = mean(nanmean(M(intersections(mi)+1:intersections(mi+1),intersections(mj)+1:intersections(mj+1))));
        end
    end
end
M = Mz;


