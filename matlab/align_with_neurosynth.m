set_paths;
subject_dirs = dir(fullfile(functional_dir, 'SQR*'));
num_subjects = length(subject_dirs);

for isubj = 2:num_subjects
	fprintf('Reslicing Subject %d\n', isubj);
	nii_files = dir(fullfile(functional_dir, subject_dirs(isubj).name, 'r_a*.nii'));
	subject_files = {nii_files(:).name};
	subject_files = fullfile(functional_dir, subject_dirs(isubj).name, subject_files);
	flags.prefix = 'nsynth-aligned';
	spm_reslice([{nsynth_reference_file_path}, subject_files], flags);
end