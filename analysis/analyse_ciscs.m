function [mean_ciscs, var_ciscs] = analyse_ciscs(ciscs, valid_folds)
	nfolds = size(ciscs,3);
	
	for iclass = 1:size(ciscs,1)
		for iratio = 1:size(ciscs,2)
			%~ fprintf('%d, %d\n', iclass, iratio)
			nonzero_folds = squeeze(valid_folds(iclass,iratio,:));
			if sum(nonzero_folds) > 0
				ciscs_slice = ciscs(iclass,iratio,nonzero_folds,:,:);
				mean_ciscs(iclass,iratio,:) = squeeze(mean(mean(ciscs_slice,4),3));
				var_ciscs(iclass,iratio,:) = squeeze(std(mean(ciscs_slice,4),0,3));
			else
				mean_ciscs(iclass,iratio,:) = zeros(1,size(ciscs,5));
				var_ciscs(iclass,iratio,:) = zeros(1,size(ciscs,5));
			end
		end
	end
end
