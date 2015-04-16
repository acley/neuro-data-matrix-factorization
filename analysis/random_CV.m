function random_CV(config, subject_data)

	for isubj = 1:length(subject_data)
		X = subject_data{isubj};
		
		% get all stimulus time slices
		idx = find(X.conditions(:,1) >= 1 & ...
					X.conditions(:,1) <= 3);
		
		% shuffle and reduce amount of data
		idx = idx(randperm(length(idx)));
		idx = idx(1:config.num_data_points);
		
		% reshape to folds
		fold_size = floor(length(idx)/config.nfolds);
		idx = idx(1:config.nfolds*fold_size);
		data{isubj} = reshape(idx,config.nfolds,fold_size);
	end
	
	for ifold = 1:config.nfolds
		fprintf('Processing fold %d.\n', ifold);
		for isubj = 1:length(subject_data)
			testidx{isubj} = data{isubj}(ifold,:);
			trainidx{isubj} = data{isubj}(setdiff(1:config.nfolds,ifold),:);
			trainidx{isubj} = reshape(trainidx{isubj},1,[]);
		end
		
		% apply CCA
		[can_act_pts, can_cmpts, dirs, scores{ifold}] = ...
			apply_cca(trainidx, testidx, subject_data, config.nfactors);
			
		[cisc(ifold, :, :), cisc_ids(ifold, :, :)] = ...
				sequ_cisc(can_cmpts);
				
		% pattern visualisation
		output_dir = fullfile(config.base_dir, 'pattern_visualisations');
		if exist(output_dir) ~= 7
			mkdir(output_dir)
		end
		num_factors = 2;
		exp_name = [num2str(config.num_data_points), 'DP-Fold', num2str(ifold),'-'];
		fix_movie_visualise_fold_patterns(subject_data, can_act_pts, output_dir, exp_name, num_factors);
	end
	
	random_visualise_cisc(config, cisc, config.base_dir);
end
