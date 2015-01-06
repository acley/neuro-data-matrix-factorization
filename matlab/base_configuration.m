function config = base_configuration()
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
	% folder with data prepared as cca input
	config.cca_input_dir = fullfile(config.working_root_dir, 'cca_input');
	% folder with cca output data
	config.cca_output_dir = fullfile(config.working_root_dir, 'cca_output');
	% folder with data prepared for the analysis wrt neurosynth
	config.analysis_input_dir = fullfile(config.working_root_dir, 'analysis_input');

	% ===== output directories =====
	% folder with the output of the analysis wrt neurosynth
	config.analysis_output_dir = fullfile(config.output_root_dir, 'analysis_output');
end
