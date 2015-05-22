function [mean_scores, var_scores] = analyse_scores(scores, valid_folds)
	nfolds = size(scores,3);
	
	for iclass = 1:size(scores,1)
		for iratio = 1:size(scores,2)
			%~ fprintf('%d, %d\n', iclass, iratio)
			nonzero_folds = squeeze(valid_folds(iclass,iratio,:));
			if sum(nonzero_folds) > 0
				mean_scores(iclass,iratio,:) = squeeze(mean(scores(iclass,iratio,nonzero_folds,:),3));
				var_scores(iclass,iratio,:) = squeeze(std(scores(iclass,iratio,nonzero_folds,:),0,3));
			else
				mean_scores(iclass,iratio,:) = zeros(1,size(scores,4));
				var_scores(iclass,iratio,:) = zeros(1,size(scores,4));
			end
		end
	end
end
