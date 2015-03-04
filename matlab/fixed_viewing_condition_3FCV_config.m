function config = fixed_viewing_condition_3FCV()
% separate by viewing condition, CV folds over movie ids (3 fold CV)


% directories
config.experiment_name = 'fixed_viewing_condition_3FCV';
if ispc == 1
else
	config.subject_data_dir = '/home/achim/Data/sequrea/working/masterprojekt/input_subject_data';
	config.base_dir = '/home/achim/Data/sequrea/working/projekt';
	config.working_root_dir = '/home/achim/Data/sequrea/working/masterprojekt';
	config.nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');
end
config.base_dir = fullfile(config.base_dir, config.experiment_name);
if exist(config.base_dir) ~= 7
	mkdir(config.base_dir);
end

% functions
config.cca_output = @fixed_viewing_condition_3FCV_CCA;
config.vis_folds = @visualise_folds;
config.vis_cisc = @visualise_cisc;
config.pts_histograms = @plot_pattern_histograms;

% settings
config.kernel = 1; % 1: linear, else: gaussian
config.nsubjectss = 3;
config.nfactors = 10;
config.ncisc_factors = 5;
end

