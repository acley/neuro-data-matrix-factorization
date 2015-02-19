% setup paths for fix_single_condition_contrast experiment

rng('default'); % fix random number generator. necessary?

subject_data_dir = '/home/achim/Data/sequrea/working/masterprojekt/input_subject_data';

base_dir = '/home/achim/Data/sequrea/working/projekt';

experiment_name = 'fixed_viewing_condition';

% nsynth paths
config.working_root_dir = '/home/achim/Data/sequrea/working/masterprojekt';
nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');


cca_output_base_dir = fullfile(base_dir, 'cca_output');
cca_output_dir = fullfile(cca_output_base_dir, [experiment_name, '_cv']);
if exist(cca_output_dir) ~= 7
	mkdir(cca_output_dir);
end

cca_output_averaged_dir = fullfile(cca_output_base_dir, [experiment_name, '_averaged']);
if exist(cca_output_averaged_dir) ~= 7
	mkdir(cca_output_averaged_dir);
end

random_data_path = fullfile(cca_output_base_dir, 'random_weights.mat');

visualisation_base_dir = fullfile(base_dir, 'cca_output_visualisations');
cca_visualisation_dir = fullfile(visualisation_base_dir, [experiment_name, '_cv']);
if exist(cca_visualisation_dir) ~= 7
	mkdir(cca_visualisation_dir);
end