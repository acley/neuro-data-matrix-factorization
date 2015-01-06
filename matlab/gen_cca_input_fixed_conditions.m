function cca_input = gen_cca_input_fixed_conditions(config, colorcond, depthcond)
	subjs = dir(fullfile(config.input_subject_data_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	fprintf('Extracting training data for conditions %d - %d\n', colorcond, depthcond);
	for isubj = 1:num_subjects
		fprintf('\tsubject %s: %s\n', num2str(isubj), subjs{isubj});
		X = load(fullfile(config.input_subject_data_dir, subjs{isubj}));
		
		% find time slices of all movies matching the given color and depth conditions
		idx = find(X.conditions(:,1)>0 & ...
					X.conditions(:,1)<=3 & ...
					X.conditions(:,2)==colorcond & ...
					X.conditions(:,3)==depthcond);
		% sort by movie id
		[~,sortidx] = sort(X.conditions(idx,1));
		trainidx{isubj} = idx(sortidx)';
		cca_input_lin{isubj} = X.K_lin(trainidx{isubj},trainidx{isubj});
		cca_input_gauss{isubj} = X.K_gauss(trainidx{isubj}, trainidx{isubj});
	end
	
	% save to file
	col_str = 'Col';
	depth_str = 'Depth';
	if colorcond == 0
		col_str = 'noCol';
	end
	if depthcond == 0
		depth_str = 'noDepth';
	end
	
	filename = ['fixed_conditions_', col_str, '_', depth_str, '.mat'];
	save(fullfile(config.cca_input_fixed_conditions_dir, filename), ...
		'cca_input_lin', 'cca_input_gauss', 'trainidx');
end
