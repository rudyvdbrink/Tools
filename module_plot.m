function module_plot(modz,center,plotopts)
%usage: module_plot(modz,center,plotopts)

if nargin < 1 || isempty(center)
    help module_plot
    return
end

if nargin < 3 || isempty(center)
    center = 0;
end

defaultopts={'-k'};
if nargin<3 || isempty(plotopts)
    plotopts=defaultopts; 
end
if ~iscell(plotopts)
    plotopts={plotopts}; 
end


intersections = find(diff(modz));
nintersections = length(intersections);

shg
hold on

if ~center
    plot([intersections; intersections]+0.5,repmat([0; length(modz)+0.5],[1 nintersections]),plotopts{:})
    plot(repmat([0; length(modz)+0.5],[1 nintersections]),[intersections; intersections]+0.5,plotopts{:})
else
    intersections = [-0.5 intersections length(modz) length(modz)];
    for seci = 1:nintersections
        plot([intersections(seci+1) intersections(seci+1)]+0.5,[intersections(seci) intersections(seci+2)]+0.5,plotopts{:})
        plot([intersections(seci) intersections(seci+2)]+0.5,[intersections(seci+1) intersections(seci+1)]+0.5,plotopts{:})
    end

end

