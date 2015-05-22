function [idcs, labels] = fix_single_condition_idcs(config, subject_data)
	for icolcond = 1:2
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract data points of current viewing condition
			idx = find(X.conditions(:,1)>0 & ...
						X.conditions(:,1)<=3 & ...
						X.conditions(:,2)==icolcond-1);
							
			% shuffle points
			rand_idx = randperm(length(idx));
			idx = idx(rand_idx);
			
			% drop data points to match fold size
			fold_size = floor(length(idx)/config.nfolds);
			used_data = fold_size * config.nfolds;
			idx = idx(1:used_data);
			
			% reshape into folds
			cond_idx = icolcond;
			idcs(cond_idx, isubj, :, :) = reshape(idx, config.nfolds, fold_size);
		end
	end
	for idepthcond = 1:2
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract data points of current viewing condition
			idx = find(X.conditions(:,1)>0 & ...
						X.conditions(:,1)<=3 & ...
						X.conditions(:,3)==idepthcond-1);
							
			% shuffle points
			rand_idx = randperm(length(idx));
			idx = idx(rand_idx);
			
			% drop data points to match fold size
			fold_size = floor(length(idx)/config.nfolds);
			used_data = fold_size * config.nfolds;
			idx = idx(1:used_data);
			
			% reshape into folds
			cond_idx = 2 + idepthcond;
			idcs(cond_idx, isubj, :, :) = reshape(idx, config.nfolds, fold_size);
		end
	end
	
	labels = {'b&w', 'color', '2D', '3D'};
end
