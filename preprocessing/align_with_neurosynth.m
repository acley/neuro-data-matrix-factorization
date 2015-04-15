function align_with_neurosynth(config)
	subject_dirs = dir(fullfile(config.functional_dir, 'SQR*'));
	num_subjects = length(subject_dirs);

	for isubj = 1:num_subjects
		fprintf('Reslicing Subject %d\n', isubj);
		nii_files = dir(fullfile(config.functional_dir, subject_dirs(isubj).name, 'wr*.nii'));
		subject_files = {nii_files(:).name};
		subject_files = fullfile(config.functional_dir, subject_dirs(isubj).name, subject_files);
		flags.prefix = 'nsynth-aligned_';
		% das nsynth reference file ist ein zufaellig gewaehltes .nii file vom neurosynth datensatz
		spm_reslice([{config.nsynth_ref_file}, subject_files], flags);
	end
end
