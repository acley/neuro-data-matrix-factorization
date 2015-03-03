rng('default');

if ispc == 1
else
	subject_data_dir = '/home/achim/Data/sequrea/working/masterprojekt/input_subject_data';
	base_dir = '/home/achim/Data/sequrea/working/projekt';
	config.working_root_dir = '/home/achim/Data/sequrea/working/masterprojekt';
	nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');
end

experiment_name = 'fixed_viewing_condition';

base_dir = fullfile(base_dir, experiment_name);


%% setup paths for fix_single_condition_contrast experiment

%rng('default'); % fix random number generator. necessary?


%if ispc == 1
%	base_dir = 'D:\home\achim\Masterprojekt\working';
%	subject_data_dir = 'D:\home\achim\Masterprojekt\working\input_subject_data';
%	nsynth_pattern_dir = 'D:\home\achim\Masterprojekt\working\input_nsynth_pattern';
%	functional_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\functional';
%	structural_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\structural';
%	logfile_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\logfiles';
%	nsynth_reference_file_path = 'D:\home\achim\Masterprojekt\ORIGINAL\functional\ability_pAgF_z.nii';
%	preprocessed_data_dir = 'D:\home\achim\Masterprojekt\working\preprocessed_data';
%else
%	subject_data_dir = '/home/achim/Data/sequrea/working/masterprojekt/input_subject_data';
%	base_dir = '/home/achim/Data/sequrea/working/projekt';
%	% nsynth paths
%	config.working_root_dir = '/home/achim/Data/sequrea/working/masterprojekt';
%	nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');
%end

%experiment_name = 'fixed_viewing_condition';

%cca_output_base_dir = fullfile(base_dir, 'cca_output');
%cca_output_dir = fullfile(cca_output_base_dir, [experiment_name, '_cv']);
%if exist(cca_output_dir) ~= 7
%	mkdir(cca_output_dir);
%end

%cca_output_averaged_dir = fullfile(cca_output_base_dir, [experiment_name, '_averaged']);
%if exist(cca_output_averaged_dir) ~= 7
%	mkdir(cca_output_averaged_dir);
%end

%%cca_output_random_dir = fullfile(cca_output_base_dir, [experiment_name, '_random']);
%%if exist(cca_output_random_dir) ~= 7
%%	mkdir(cca_output_random_dir);
%%end

%%random_data_path = fullfile(cca_output_base_dir, 'random_weights.mat');

%visualisation_base_dir = fullfile(base_dir, 'cca_output_visualisations');
%cca_visualisation_dir = fullfile(visualisation_base_dir, [experiment_name, '_cv']);
%if exist(cca_visualisation_dir) ~= 7
%	mkdir(cca_visualisation_dir);
%end
