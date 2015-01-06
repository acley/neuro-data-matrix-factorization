function correlations = simple_correlation(subj_data_dir,...
											average_pattern_dir,...
											nsynth_pattern_dir,...
											output_dir,...
											nsynth_nifti_dir)

	% directory for the subject masks
	subjs = dir(fullfile(subj_data_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	% directory for subject patterns
	experiments = dir(fullfile(average_pattern_dir, '*.mat'));
	experiments = {experiments(:).name};
	num_experiments = size(experiments,2);
	
	% directory for the nsynth patterns
	nsynth_pat_blocks = dir(fullfile(nsynth_pattern_dir, '*.mat'));
	nsynth_pat_blocks = {nsynth_pat_blocks(:).name};
	num_nsynth_blocks = size(nsynth_pat_blocks, 2);
	
	for iexp = 1:num_experiments
		fprintf('Experiment %d: %s: ', iexp, experiments{iexp});
		% load average sqr activation pattern
		av_pattern_lin = load(fullfile(average_pattern_dir, experiments{iexp}), 'av_pattern_lin');
		av_pattern_lin = av_pattern_lin.av_pattern_lin';
		av_pattern_gauss = load(fullfile(average_pattern_dir, experiments{iexp}), 'av_pattern_gauss');
		av_pattern_gauss = av_pattern_gauss.av_pattern_gauss';
		
		% init correlation matrix
		c_lin = [];
		c_gauss = [];
	
		for iblock = 1:num_nsynth_blocks
			fprintf('=');
			% load block
			block_patterns = load(fullfile(nsynth_pattern_dir, nsynth_pat_blocks{iblock}));
			block_patterns = block_patterns.dat;
			
			c_lin = [c_lin, corr(av_pattern_lin, block_patterns)];
			c_gauss = [c_gauss, corr(av_pattern_gauss, block_patterns)];
		end
		fprintf('\n')
		correlations_lin{iexp} = c_lin;
		correlations_gauss{iexp} = c_gauss;
	end
	
	features = get_nsynth_feature_names(nsynth_nifti_dir);
	
	save(fullfile(output_dir, 'results.mat'),...
		'correlations_lin', 'correlations_gauss', 'experiments', 'features');
end
