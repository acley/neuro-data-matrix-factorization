function [pwc ids]= sequ_cisc(canonical_components,idx)
% computes pairwise canonical intersubject correlations given a cell array
% of canonical components (arranged as time-by-ncomp matrices)

if ~exist('idx','var'),
    idx = 1:size(canonical_components{1},1);
end

ncomp = size(canonical_components{1},2);
pwc = zeros([length(canonical_components),length(canonical_components),ncomp]);

for isubj = 1:length(canonical_components)
    for osubj =1:length(canonical_components)
        if isubj<osubj
            for icomp = 1:ncomp
                pwc(isubj,osubj,icomp) = abs(corr(canonical_components{isubj}(idx,icomp),canonical_components{osubj}(idx,icomp)));
            end
        end
    end
end

[ids(:,1) ids(:,2)] = find(pwc(:,:,1));
pwc = reshape(pwc,[length(canonical_components)^2,ncomp]);
pwc = pwc(find(sum(pwc,2)>0),:);
