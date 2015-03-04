function config = preprocessing_config()
	% config.subject_data_dir = 'D:\home\achim\Masterprojekt\working\input_subject_data';
	% config.nsynth_pattern_dir = 'D:\home\achim\Masterprojekt\working\input_nsynth_pattern';
	config.logfile_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\logfiles';
	% config.nsynth_reference_file_path = 'D:\home\achim\Masterprojekt\ORIGINAL\functional\ability_pAgF_z.nii';
	config.functional_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\functional';
	config.structural_dir = 'D:\home\achim\Masterprojekt\ORIGINAL\structural';
	% config.preprocessed_data_dir = 'D:\home\achim\Masterprojekt\working\preprocessed_data_unaligned';
	config.preprocessed_data_dir = 'D:\home\achim\Masterprojekt\working\preprocessed_data';
	config.pattern_string = 'nsynth*.nii';
	% config.pattern_string = 'r_a*.nii';
end