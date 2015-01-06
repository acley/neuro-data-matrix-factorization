function gen_kernel_matrices(config, linearkernel_flag)

	% find subject data mat files
	subjs = dir(fullfile(config.input_preprocessed_dir, '*.mat'));
	subjs = {subjs(:).name};
	num_subjects = size(subjs,2);
	
	for isubj = 1:num_subjects
		fprintf('Processing Subject %d: %s\n', isubj, subjs{isubj});
		
		fprintf('\tCalculating z-scores of measurements\n')
		subj_data = load(fullfile(config.input_preprocessed_dir, subjs{isubj}));
		dat = subj_data.dat;
		dat = zscore(dat')';
		
		fprintf('\tLinear Kernel\n')
		K_lin = dat'*dat;
		K_lin = K_lin./max(eigs(K_lin));
		all_kernels_lin{isubj} = K_lin;
		
		fprintf('\tGaussian Kernel\n')
		kwidths = est_kwidth(dat',5);
		K_gauss = gausskern(dat',dat',kwidths(3));
		K_gauss = K_gauss./max(eigs(K_gauss));
		all_kernels_gauss{isubj} = K_gauss;
		
		
		% save updated subject data
		TR = subj_data.TR;
		grey_threshold = subj_data.grey_threshold;
		gmask = subj_data.gmask;
		conditions = subj_data.conditions;
		save(fullfile(config.input_subject_data_dir, subjs{isubj}),...
			'TR', 'grey_threshold', 'gmask', 'dat', 'conditions', 'K_lin', 'K_gauss');
	end
	
	% save kernel matrices separately
	save(fullfile(config.input_lin_kernel_dir, 'linear_kernels.mat'), 'all_kernels_lin');
	save(fullfile(config.input_gauss_kernel_dir, 'gauss_kernels.mat'), 'all_kernels_gauss');
end
