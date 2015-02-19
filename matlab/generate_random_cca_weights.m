function generate_random_cca_weights()

set_paths;

num_training_points = 200;
num_test_points = 50;

subjs = dir(fullfile(subject_data_dir,'SQR_*'));
num_subjects = 2;%length(subjs);

fprintf('Loading subject data...\n');
linearkernel = 1;
for isubj = 1:num_subjects
	fprintf('Loading Subject %d\n',isubj)
	subject_data{isubj} = load(fullfile(subject_data_dir,subjs(isubj).name), 'conditions', 'K_lin', 'dat');
	subject_data{isubj}.K = subject_data{isubj}.K_lin;
end
fprintf('\n');

% pick 100 random data points
for isubj = 1:num_subjects
	X = subject_data{isubj};
	
	idx = find(X.conditions(:,1) > 0 & ...
				X.conditions(:,1) <= 3);
	
	rand_idcs = randperm(length(idx));
	
	trainidcs{isubj} = idx(rand_idcs(1:num_training_points));
	testidcs{isubj} = idx(num_training_points:num_training_points + num_test_points);
	Xtest{isubj} = X.K(trainidcs{isubj}, testidcs{isubj});
	Xtrain{isubj} = X.K(trainidcs{isubj}, trainidcs{isubj});
end

ncomp = 20;
[c, directions, ~] = cca(Xtrain, ncomp);

for isubj = 1:num_subjects
	canonical_components{isubj} = (directions{isubj}' * Xtest{isubj})';
	canonical_activation_patterns{isubj} = (canonical_components{isubj}' * X.dat(:,testidcs{isubj})')';
end

[cisc, cisc_ids] = sequ_cisc(canonical_components,1:10);

save(random_data_path, 'directions', 'canonical_components', 'cisc', 'cisc_ids', 'num_training_points', 'num_test_points', 'trainidcs', 'testidcs', 'canonical_activation_patterns')
