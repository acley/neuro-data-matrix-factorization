function cca_input = gen_cca_input_fixed_movie(config, movie_id)
	% subject data directory
	subjs = dir(fullfile(config.input_subject_data_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	fprintf('Extracting training data for movie %d\n', movie_id);
	for isubj = 1:num_subjects
		% load subject data
		fprintf('\tsubject %d: %s\n', isubj, subjs{isubj});
		X = load(fullfile(config.input_subject_data_dir, subjs{isubj}));
		
		% loop over all possible conditions and extract the time slices
		% that correspond to the given movie id
		idx = [];
		for idepthcond = 0:1
			for icolorcond = 0:1
				tmp_idx = find(X.conditions(:,1) == movie_id & ...
								X.conditions(:,2) == icolorcond & ...
								X.conditions(:,3) == idepthcond);
				idx = [idx; tmp_idx];	
			end
		end
		
		trainidx{isubj} = idx;
		cca_input_lin{isubj} = X.K_lin(trainidx{isubj},trainidx{isubj});
		cca_input_gauss{isubj} = X.K_gauss(trainidx{isubj}, trainidx{isubj});
	end
	
	% save to file
	filename = ['fixed_movie_', num2str(movie_id), '.mat'];
	save(fullfile(config.cca_input_fixed_movie_dir, filename), ...
		'cca_input_lin', 'cca_input_gauss', 'trainidx');
end
