function gen_sqr_pattern(config, cca_input_dir, cca_output_dir, num_components)

	% subject data directory
	subjs = dir(fullfile(config.input_subject_data_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	% cca input directory
	cca_inputs = dir(fullfile(cca_input_dir, '*.mat'));
	cca_inputs = {cca_inputs(:).name};
	num_inputs = size(cca_inputs,2);
	
	for i = 1:num_inputs
		fprintf('Processing Experiment %s\n', cca_inputs{i});
		fprintf('\t Loading Data ...\n');
		% load cca_input
		input = load(fullfile(cca_input_dir, cca_inputs{i}));
		Xtrain_lin = input.cca_input_lin;
		Xtrain_gauss = input.cca_input_gauss;
		trainidx = input.trainidx;
		
		fprintf('\t Calculating Canonical Components ...\n');
		[correlations_lin,directions_lin,~] = cca(Xtrain_lin, num_components);
		[correlations_gauss,directions_gauss,~] = cca(Xtrain_gauss, num_components);
		
		fprintf('\t Calculating Brain Activation Pattern ...\n');
		for isubj = 1:num_subjects
			fprintf('\t\t Subject %d: %s \n', isubj, subjs{isubj});
			% load subject data
			X = load(fullfile(config.input_subject_data_dir, subjs{isubj}));
			
			% calculate activation patterns
			voxel_networks_lin = directions_lin{isubj}' * Xtrain_lin{isubj};
			activation_pattern_lin{isubj} = voxel_networks_lin * X.dat(:,trainidx{isubj})';
			voxel_networks_gauss = directions_gauss{isubj}' * Xtrain_gauss{isubj};
			activation_pattern_gauss{isubj} = voxel_networks_gauss * X.dat(:,trainidx{isubj})';		
		end
		
		save(fullfile(cca_output_dir, cca_inputs{i}),...
			'activation_pattern_lin', 'correlations_lin', 'activation_pattern_gauss', 'correlations_gauss');
		clear activation_pattern_lin;
		clear activation_pattern_gauss;
	end
end
