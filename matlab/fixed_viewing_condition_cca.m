function fixed_viewing_condition_cca(ratio, subject_data)

set_paths;

if nargin < 1
	ratio = 1
end
save_path = fullfile(cca_output_dir, [num2str(ratio*100), '_percent']);
if exist(save_path)~=7
	mkdir(save_path);
end

assert(ratio > 0 && ratio <= 1);

fprintf('\nStarting Experiment with %d percent of the available training data.\n\n', ratio*100)

ncomp = 10;
maxmovs = 3;
TR = 3;

subjs = dir(fullfile(subject_data_dir,'SQR_*'));
num_subjects = length(subjs);

% if exist('subject_data')==0
if nargin < 2
	fprintf('Loading subject data...\n');
	linearkernel = 1;
	for isubj = 1:num_subjects
		fprintf('Loading Subject %d\n',isubj)
		subject_data{isubj} = load(fullfile(subject_data_dir,subjs(isubj).name), 'conditions', 'K_lin', 'dat');
		subject_data{isubj}.K = subject_data{isubj}.K_lin;
	end
	fprintf('\n');
end

% loop through all experimental conditions
for icolcond = 1:2
	for idepthcond =1:2
		fprintf('Starting CV for condition col: %d and depth: %d\n', icolcond-1, idepthcond-1);
		for movcond = 1:maxmovs
			fprintf('\tTesting on movie: %d\n',movcond);
			for isubj = 1:num_subjects
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
				if ~isempty(idx)
					% sort idcs by moiv
					[~,sortidx] = sort(X.conditions(idx,1));
					idx = idx(sortidx);
					idx = reshape(idx,length(idx)/maxmovs,maxmovs)';
					
					% train on two movies, test on one
					testidx{isubj} = idx(movcond,:);
					trainidx{isubj} = idx(setdiff(1:maxmovs,movcond),:)';
					trainidx{isubj} = reshape(trainidx{isubj},1,prod(size(trainidx{isubj})))';
					
					% reduce the amount of training data to test the robustness of the cca results
					if (ratio ~= 1)
						trainidx{isubj} = reduce_training_data(0.99, trainidx{isubj});
					end
				end
			end
			if ~isempty(idx)


				[canonical_activation_patterns, canonical_components, directions] = ...
					apply_cca(trainidx, testidx, subject_data, ncomp);

%				% compute CISC on hold out data
%				[cisc_cv(icolcond,idepthcond,movcond,:,:),cisc_ids(icolcond,idepthcond,movcond,:,:)] ...
%					= sequ_cisc(canonical_components,1:10);
				[cisc, cisc_ids] = sequ_cisc(canonical_components,1:10);
				
				% save activation patterns
				color_cond = {'color', 'b&w'};
				depth_cond = {'2D', '3D'};
				movie_cond = {'Cherryblossom','Deepsea','Rallyekorea'};
				filename = [movie_cond{movcond}, '_', color_cond{icolcond}, '_', depth_cond{idepthcond}];
%				save(fullfile(cca_output_dir, [filename, '.mat']),...
%					'canonical_activation_patterns', 'canonical_components', 'directions', 'cisc', 'cisc_ids');
				save(fullfile(save_path, [filename, '.mat']),...
					'canonical_activation_patterns', 'canonical_components', 'directions', 'cisc', 'cisc_ids');
			end
		end
        
	end
end

end

function reverse_negative_weights(c, directions)
	
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
	% assert(sum(c<0) == 0); % make sure no directions have to be inverted
    
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
