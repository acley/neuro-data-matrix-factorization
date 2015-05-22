function [idcs, label] = random_idcs(subject_data, nfolds, npoints)
	for isubj = 1:length(subject_data)
		X = subject_data{isubj};
		% pick random data from any movie
		idx = find(X.conditions(:,1)>0 & ...
					X.conditions(:,1)<=3);
		
		% shuffle & reduce to specified number of points
		rand_idx = randperm(length(idx));
		idx = idx(rand_idx(1:npoints));
		
		% split into folds	
		fold_size = floor(length(idx)/nfolds);
		num_data_points = fold_size * nfolds;
		idx = idx(1:num_data_points);
		idcs(1,isubj,:,:) = reshape(idx,nfolds,fold_size);
	end

	label = 'random';
end
