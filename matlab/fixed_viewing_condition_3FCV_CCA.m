function output = fixed_viewing_condition_3FCV_CCA(config, data_ratio, subject_data)
	base_dir = config.base_dir;
	subject_data_dir = config.subject_data_dir;
	
	if nargin < 3
		linkernel == 1;
		subject_data = load_subject_data(subject_data_dir, linkernel)
	end
	
	output_dir = fullfile(base_dir, [num2str(data_ratio*100), '_percent']);
	if exist(output_dir)~=7
		mkdir(output_dir);
	end
	
	fprintf('\nStarting Experiment with %d percent of the available training data.\n\n', data_ratio*100)
	ncomp = config.nfactors;
	ncom_cisc = config.ncisc_factors;
	maxmovs = 3;
	TR = 3;
	
	for icolcond = 1:2
		for idepthcond =1:2
			fprintf('Starting CV for condition col: %d and depth: %d\n', icolcond-1, idepthcond-1);
			for movcond = 1:maxmovs
				fprintf('\tTesting on movie: %d\n',movcond);
				for isubj = 1:length(subject_data)
					X = subject_data{isubj};
				
					% find idcs of all movies with the current depth/color conditions
					idx = find(X.conditions(:,1)>0 & ...
								X.conditions(:,1)<=maxmovs & ...
								X.conditions(:,2)==icolcond-1 & ...
								X.conditions(:,3)==idepthcond-1);
					% extract order of stimuli
					condorder(idepthcond,icolcond,movcond,isubj)=...
						ceil(find(X.conditions(:,1) == movcond & ...
								X.conditions(:,2)==icolcond-1 & ...
								X.conditions(:,3)==idepthcond-1,1,'first')*TR/(120+20));
					assert(~isempty(idx))
				
					% sort idcs by movie
					[~,sortidx] = sort(X.conditions(idx,1));
					idx = idx(sortidx);
					idx = reshape(idx,length(idx)/maxmovs,maxmovs)';
				
					% train on two movies, test on one
					testidx{isubj} = idx(movcond,:);
					trainidx{isubj} = idx(setdiff(1:maxmovs,movcond),:)';
					trainidx{isubj} = reshape(trainidx{isubj},1,prod(size(trainidx{isubj})))';
				
					% reduce the amount of training data to test the robustness of the cca results
					if (data_ratio ~= 1)
						trainidx{isubj} = reduce_training_data(data_ratio, trainidx{isubj});
					end
				
					idx_lengths{isubj} = [length(trainidx{isubj}), length(testidx{isubj})];
%					[rand_trainidx{isubj}, rand_testidx{isubj}] = ...
%						create_random_data(length(trainidx{isubj}), length(testidx{isubj}), X);
				end
			
				assert(isequal(idx_lengths{:}) == 1); % check if all training/test size is the same for all subjects
			
				% apply cca to real data and random data
				[can_act_pts{icolcond, idepthcond, movcond},...
					can_cmpts{icolcond, idepthcond, movcond},...
					dirs{icolcond, idepthcond, movcond}] = apply_cca(trainidx, testidx, subject_data, ncomp);
				
				[cisc(icolcond,idepthcond,movcond,:,:), cisc_ids(icolcond,idepthcond,movcond,:,:)] = ...
					sequ_cisc(can_cmpts{icolcond, idepthcond, movcond}, 1:ncom_cisc);
			end   
		end
	end
	
	fprintf('\nCalculating average activation patterns.\n');
	av_can_act_pts = average_pattern_over_folds(can_act_pts);

	fprintf('\nSaving results.\n');
	save(fullfile(output_dir, 'cca_output.mat'),...
		'can_act_pts', 'can_cmpts', 'dirs', 'cisc', 'cisc_ids');
	save(fullfile(output_dir, 'average_patterns.mat'), 'av_can_act_pts');
	
	% preparing output
	output.av_can_act_pts = av_can_act_pts;
	output.can_act_pts = can_act_pts;
	output.cisc = cisc;
	output.cisc_ids = cisc_ids;
end

function [activation_patterns, canonical_components, directions] = ...
				apply_cca(trainidcs, testidcs, subject_data, ncomp)
	
	assert(length(trainidcs) == length(testidcs));
	
	[Xtrain, Xtest] = prepare_data(trainidcs, testidcs, subject_data);
	
	% find canonical components
	[c,directions,~] = cca(Xtrain,ncomp);
	if (sum(c<0) ~= 0)
		c
	end
	assert(sum(c<0) == 0); % make sure no directions have to be inverted
    
	% compute canonical activation patterns on test data
	for isubj=1:length(trainidcs)
		% can_comp: transpose (txf) because of cisc_cv requirement)
		canonical_components{isubj} = (directions{isubj}' * Xtest{isubj})';
		X = subject_data{isubj};
		activation_patterns{isubj} = ...
			(canonical_components{isubj}' * X.dat(:,testidcs{isubj})')';
	end
end

function [Xtrain, Xtest] = prepare_data(trainidcs, testidcs, subject_data)
	for isubj = 1:length(trainidcs)
		Xtrain{isubj} = subject_data{isubj}.K(trainidcs{isubj}, trainidcs{isubj});
		Xtest{isubj} = subject_data{isubj}.K(trainidcs{isubj}, testidcs{isubj});
	end
end

function new_idcs = reduce_training_data(ratio, train_idcs)
	splitpoint = round(ratio*length(train_idcs));
	assert(splitpoint < length(train_idcs) && splitpoint > 0);
	rand_idcs = randperm(length(train_idcs));
	new_idcs = train_idcs(rand_idcs(1:splitpoint));
end
