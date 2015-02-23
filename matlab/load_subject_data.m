function subject_data = load_subject_data()
	set_paths;

	fprintf('Loading subject data...\n');
	
	subjs = dir(fullfile(subject_data_dir,'SQR_*'));
	num_subjects = length(subjs);
	
	linearkernel = 1;
	for isubj = 1:num_subjects
		fprintf('Loading Subject %d\n',isubj)
		subject_data{isubj} = load(fullfile(subject_data_dir,subjs(isubj).name), 'conditions', 'K_lin', 'dat');
		subject_data{isubj}.K = subject_data{isubj}.K_lin;
	end
	fprintf('\n');
end