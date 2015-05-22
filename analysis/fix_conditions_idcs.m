function [idcs, labels] = fix_conditions_idcs(subject_data, nfolds)
	for icolcond = 1:2
		for idepthcond = 1:2
			for isubj = 1:length(subject_data)
				X = subject_data{isubj};
				
				% extract data points of current viewing condition
				idx = find(X.conditions(:,1)>0 & ...
							X.conditions(:,1)<=3 & ...
							X.conditions(:,2)==icolcond-1 & ...
							X.conditions(:,3)==idepthcond-1);
								
				% shuffle points
				rand_idx = randperm(length(idx));
				idx = idx(rand_idx);
				
				% drop data points to match fold size
				fold_size = floor(length(idx)/nfolds);
				used_data = fold_size * nfolds;
				idx = idx(1:used_data);
				
				% reshape into folds
				cond_idx = (icolcond-1)*2 + idepthcond;
				idcs(cond_idx, isubj, :, :) = reshape(idx, nfolds, fold_size);
			end
		end
	end
	
	labels = {'b&w - 2D', 'b&w - 3D', 'color - 2D', 'color - 3D'};
end
