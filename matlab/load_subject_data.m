function subject_data = load_subject_data(subject_data_dir, linearkernel)
	if nargin < 2
		linearkernel == 1;
	end

	fprintf('Loading subject data...\n');
	
	subjs = dir(fullfile(subject_data_dir,'SQR_*'));
	num_subjects = length(subjs);
	
	for isubj = 1:3%num_subjects
		fprintf('Loading Subject %d\n',isubj)
		subject_data{isubj} = load(fullfile(subject_data_dir,subjs(isubj).name), 'conditions', 'K_lin', 'K_gauss', 'dat');
		if linearkernel == 1
			subject_data{isubj}.K = subject_data{isubj}.K_lin;
		else
			subject_data{isubj}.K = subject_data{isubj}.K_gauss;
		end
	end
	fprintf('\n');
end
