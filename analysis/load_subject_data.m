function subject_data = load_subject_data(subject_data_dir, kernel, nsubjects)
	if nargin < 2
		kernel == 1;
	end

	fprintf('Loading subject data...\n');
	
	subjs = dir(fullfile(subject_data_dir,'SQR_*'));
	num_subjects = min(nsubjects, length(subjs));
	
	for isubj = 1:num_subjects
		fprintf('Loading Subject %d with ',isubj)
		subject_data{isubj} = load(fullfile(subject_data_dir,subjs(isubj).name),...
									 'conditions', 'K_lin', 'K_gauss', 'dat', 'gmask');
		if kernel == 1
			fprintf('linear kernel.\n');
			subject_data{isubj}.K = subject_data{isubj}.K_lin;
		else
			fprintf('gaussian kernel.\n');
			subject_data{isubj}.K = subject_data{isubj}.K_gauss;
		end
	end
	fprintf('\n');
end
