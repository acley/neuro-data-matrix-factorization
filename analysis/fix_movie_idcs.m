function [idcs, labels] = fix_movie_idcs(subject_data, nfolds)
	for imovie = 1:3
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract data points of current viewing condition
			idx = find(X.conditions(:,1) == imovie);
							
			% shuffle points
			rand_idx = randperm(length(idx));
			idx = idx(rand_idx);
			
			% drop data points to match fold size
			fold_size = floor(length(idx)/nfolds);
			used_data = fold_size * nfolds;
			idx = idx(1:used_data);
			
			% reshape into folds
			cond_idx = imovie;
			idcs(cond_idx, isubj, :, :) = reshape(idx, nfolds, fold_size);
		end
	end
	labels = {'Cherryblossom','Deep Sea','Ralley Korea'};
end
