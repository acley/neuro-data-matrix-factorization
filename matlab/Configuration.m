config.num_components = 10;

% ===== base directories =====
config.input_root_dir = '/home/achim/Data/sequrea/input/masterprojekt';
config.working_root_dir = '/home/achim/Data/sequrea/working/masterprojekt';
config.output_root_dir = '/home/achim/Data/sequrea/output/masterprojekt';
config.original_root_dir = '/home/achim/Data/sequrea/ORIGINAL';

% ===== input data directories =====
% Nifti files of subjects that are aligned with neurosynth
config.input_aligned_dir = fullfile(config.original_root_dir, 'aligned_with_neurosynth');
% Nifti files of structural images of the sequrea scans
config.structural_images_dir = fullfile(config.original_root_dir, 'structural');
% sqr experiment log files
config.sqr_logfiles_dir = fullfile(config.original_root_dir,'logfiles');
% subject data mat files after preprocessing (filtering and masking)
config.input_preprocessed_dir = fullfile(config.input_root_dir, 'aligned_and_preprocessed');
% Neurosynth Nifti files
config.input_nsynth_nifti_dir = fullfile(config.input_root_dir, 'nsynth_pattern');

% ===== working directories =====
% subject data mat files with added kernel matrices
config.input_subject_data_dir = fullfile(config.working_root_dir, 'input_subject_data');
config.input_lin_kernel_dir = fullfile(config.working_root_dir, 'input_lin_kernel');
config.input_gauss_kernel_dir = fullfile(config.working_root_dir, 'input_gauss_kernel');
% Neurosynth pattern blocks
config.input_nsynth_pattern_dir = fullfile(config.working_root_dir, 'input_nsynth_pattern');
% kCCA input folder
config.cca_input_dir = fullfile(config.working_root_dir, 'cca_input');
config.cca_input_fixed_conditions_dir = fullfile(config.cca_input_dir, 'fixed_conditions_all_movies');
config.cca_input_fixed_movie_dir = fullfile(config.cca_input_dir, 'fixed_movie_all_conditions');
% kCCA output folder with mat files of activation patterns
config.cca_output_dir = fullfile(config.working_root_dir, 'cca_output');
config.cca_output_fixed_conditions_dir = fullfile(config.cca_output_dir, 'fixed_conditions_all_movies');
config.cca_output_fixed_movie_dir = fullfile(config.cca_output_dir, 'fixed_movie_all_conditions');
% average activation patterns
config.average_activation_dir = fullfile(config.working_root_dir, 'average_activation');
config.av_act_fixed_conditions_dir = fullfile(config.average_activation_dir, 'fixed_conditions_all_movies');
config.av_act_fixed_movie_dir = fullfile(config.average_activation_dir, 'fixed_movie_all_conditions');
% simple correlation analysis data directory
config.simple_correlation_dir = fullfile(config.working_root_dir, 'simple_correlation_data');
config.simple_correlation_fixed_conditions_dir = fullfile(config.simple_correlation_dir, 'fixed_conditions_all_movies');
config.simple_correlation_fixed_movie_dir = fullfile(config.simple_correlation_dir,'fixed_movie_all_conditions');

% ===== output directories =====
% simple correlation output
config.simple_correlation_output_dir = fullfile(config.output_root_dir, 'simple_correlation_output');
config.simple_correlation_output_fixed_conditions_dir = fullfile(config.simple_correlation_output_dir, 'fixed_conditions_all_movies');
config.simple_correlation_output_fixed_movie_dir = fullfile(config.simple_correlation_output_dir, 'fixed_movie_all_conditions');


