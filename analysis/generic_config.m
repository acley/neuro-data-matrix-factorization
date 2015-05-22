function config = generic_config(name, kernel, nfolds, nfactors, used_data)
	config.kernel = kernel;		% 1:linear, 2: gaussian
	config.nfolds = nfolds;		% number of folds for CV
	config.nfactors = nfactors;	% number of factors for the CCA
	config.used_data = used_data;
	
	% experiment name
	if config.kernel == 1
		kernel_str = '_linK';
	else
		kernel_str = '_gaussK';
	end
	config.experiment_name = [name, kernel_str];
	
	% directories
	if ispc == 1
		config.subject_data_dir = 'D:\home\achim\Masterprojekt\working\input_subject_data';
		config.nsynth_pattern_dir = 'D:\home\achim\Masterprojekt\working\input_nsynth_pattern';
		config.preprocessed_data_dir = 'D:\home\achim\Masterprojekt\working\preprocessed_data_unaligned';
		config.base_dir = 'D:\home\achim\Masterprojekt\working';
	else
		config.subject_data_dir = '/home/achim/Data/dummy_sequrea/preprocessed_data';
		config.base_dir = '/home/achim/Data/dummy_sequrea/working/';
		config.nsynth_dir = '/home/achim/Data/dummy_sequrea/nsynth-pattern-pFgA';
	end
	c = fix(clock());
	time_str = [date(), '-', num2str(c(4)), '-', num2str(c(5))];
	config.base_dir = fullfile(config.base_dir, [config.experiment_name, '-', time_str]);
	if exist(config.base_dir) ~= 7
		mkdir(config.base_dir);
	end
	
	save(fullfile(config.base_dir, 'config.m'), 'config');
end
