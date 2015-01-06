function gen_average_activation_pattern(subject_dat_dir, average_activation_input_dir, average_activation_output_dir)

	% directory for the subject masks
	subjs = dir(fullfile(subject_dat_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	% directory for subject patterns
	experiments = dir(fullfile(average_activation_input_dir, '*.mat'));
	experiments = {experiments(:).name};
	num_experiments = size(experiments,2);
	
	% init average activation pattern
	subj_mask = load(fullfile(subject_dat_dir, subjs{1}), 'gmask');
	voxel_space = numel(subj_mask.gmask);
	num_components = config.num_components; % TODO: load dynamically from subject pattern
	av_pattern_lin = zeros(num_components, voxel_space);
	av_pattern_gauss = zeros(num_components, voxel_space);
	
	for iexp = 1:num_experiments
		fprintf('Calculating the Average Activation Pattern for experiment %d: %s\n', iexp, experiments{iexp});
		for isubj = 1:num_subjects
			fprintf('\tAdding Subject %d:\t', isubj);
			subj_mask = load(fullfile(subject_dat_dir, subjs{isubj}), 'gmask');
			subj_mask = reshape(subj_mask.gmask, numel(subj_mask.gmask), []);
			subj_pattern_lin = load(fullfile(average_activation_input_dir, experiments{iexp}),...
									'activation_pattern_lin');
			subj_pattern_lin = subj_pattern_lin.activation_pattern_lin;
			subj_pattern_gauss = load(fullfile(average_activation_input_dir, experiments{iexp}),...
										'activation_pattern_gauss');
			subj_pattern_gauss = subj_pattern_gauss.activation_pattern_gauss;
			for icomp = 1:num_components
				fprintf('-');
				av_pattern_lin(icomp, subj_mask) = av_pattern_lin(icomp, subj_mask) + ...
													subj_pattern_lin{isubj}(icomp,:);
				av_pattern_gauss(icomp, subj_mask) = av_pattern_gauss(icomp, subj_mask) + ...
													subj_pattern_gauss{isubj}(icomp,:);
			end
			fprintf('\n');
		end
		
		av_pattern_lin = av_pattern_lin/num_subjects;
		av_pattern_gauss = av_pattern_gauss/num_subjects;		
		save(fullfile(average_activation_output_dir, experiments{iexp}), 'av_pattern_lin', 'av_pattern_gauss');
		av_pattern_lin = zeros(num_components, voxel_space);
		av_pattern_gauss = zeros(num_components, voxel_space);
	end
end
