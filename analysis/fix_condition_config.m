function config = fixed_condition_config()

	% functions
	config.cca_output = @fix_condition_CV;
%	config.vis_folds = @visualise_folds;
%	config.vis_cisc = @visualise_cisc;
%	config.pts_histograms = @plot_pattern_histograms;

	% settings
	config.kernel = 2; % 1: linear, else: gaussian
	config.used_data = 1.0; % percentage of data used for training (to test the robustness of the method)
	config.nfolds = 5;
	config.nfactors = 10;

	% directories
	if config.kernel == 1
		kernel_str = '_linK';
	else
		kernel_str = '_gaussK';
	end
	config.experiment_name = ['fixed_viewing_condition_sanity_checks', kernel_str];
	if ispc == 1
		config.subject_data_dir = 'D:\home\achim\Masterprojekt\working\input_subject_data';
		config.nsynth_pattern_dir = 'D:\home\achim\Masterprojekt\working\input_nsynth_pattern';
		config.preprocessed_data_dir = 'D:\home\achim\Masterprojekt\working\preprocessed_data_unaligned';
		config.base_dir = 'D:\home\achim\Masterprojekt\working';
	else
		config.subject_data_dir = '/home/achim/Data/dummy_sequrea/preprocessed_data';
		config.base_dir = '/home/achim/Data/dummy_sequrea/';
%		config.nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');
	end
	config.base_dir = fullfile(config.base_dir, config.experiment_name);
	if exist(config.base_dir) ~= 7
		mkdir(config.base_dir);
	end
end
