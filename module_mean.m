function M = module_mean(M,modz,collapse)
%usage: M = module_mean(M,modz,collapse)

M(logical(size(M))) = NaN; %set diagonal to NaN

intersections = find(diff(modz));
intersections = [0 intersections length(modz)];

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


