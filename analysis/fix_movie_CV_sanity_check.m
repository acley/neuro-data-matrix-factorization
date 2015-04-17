function output = fix_movie_CV_sanity_check(config, subject_data)

	for imovie = 1:3
		% separate time slices of each movie for each subject
		fprintf('Extracting time slices of movie %d.\n', imovie);
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract time slices of current movie
			idx = find(X.conditions(:,1) == imovie);
			
			% shuffle slices
			idx = idx(randperm(length(idx)));
			
			% reshape to folds
			fold_size = floor(length(idx)/config.nfolds);
			idx = idx(1:config.nfolds*fold_size);
			data{imovie,isubj} = reshape(idx,config.nfolds,fold_size);
		end
	
		for ifold = 1:config.nfolds
			fprintf('\tProcessing fold %d of %d.\n', ifold, config.nfolds);
			for isubj = 1:length(subject_data)
				% split into training and test data
				testidx{isubj} = data{imovie,isubj}(ifold,:);
				trainidx{isubj} = data{imovie,isubj}(setdiff(1:config.nfolds,ifold),:);
				trainidx{isubj} = reshape(trainidx{isubj},1,[]);
		
				% TODO: reduce training data according to data_ratio
			
				idxlengths{isubj} = [length(trainidx{isubj}), length(testidx{isubj})];
			end
			% check if all training/test size is the same for all subjects
			assert(isequal(idxlengths{:}) == 1);
		
			% apply CCA
			[can_act_pts, can_cmpts, dirs, scores{imovie,ifold}] = ...
				apply_cca(trainidx, testidx, subject_data, config.nfactors);
				
			[cisc(imovie, ifold, :, :), cisc_ids(imovie, ifold, :, :)] = ...
					sequ_cisc(can_cmpts);
			
			% pattern visualisation		
%			output_dir = fullfile(config.base_dir, 'pattern_visualisations');
%			if exist(output_dir) ~= 7
%				mkdir(output_dir)
%			end
%			exp_name = ['Movie',num2str(imovie),'-Fold',num2str(ifold),'-'];
%			num_factors = 2;
%			fix_movie_visualise_fold_patterns(subject_data, can_act_pts, output_dir, exp_name,num_factors);
		end
	end
	
	output.cisc = cisc;
	output.scores = scores;
end
