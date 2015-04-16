function output = fixed_condition_CV(config, subject_data)
	
	for icolcond = 1:2
		for idepthcond =1:2
			fprintf('\nStarting CV for condition col: %d and depth: %d\n', icolcond-1, idepthcond-1);
			for isubj = 1:length(subject_data)
				X = subject_data{isubj};
			
				% find idcs of all movies with the current depth/color conditions
				idx = find(X.conditions(:,1)>0 & ...
							X.conditions(:,1)<=3 & ...
							X.conditions(:,2)==icolcond-1 & ...
							X.conditions(:,3)==idepthcond-1);
				assert(~isempty(idx))
				
				% random permutation & reduction of training set
				fold_size = floor(length(idx)/config.nfolds);
				num_data_points = fold_size * config.nfolds;
				rand_idx = randperm(length(idx));
				idx = idx(rand_idx(1:config.nfolds*fold_size));
				
				% 1 row per fold
				data_idcs{icolcond,idepthcond,isubj} = reshape(idx, config.nfolds, fold_size);
			end
			
			for ifold = 1:config.nfolds
				for isubj = 1:length(subject_data)
					testidx{isubj} = data_idcs{icolcond,idepthcond,isubj}(ifold,:);
					trainidx{isubj} = data_idcs{icolcond,idepthcond,isubj}(setdiff(1:config.nfolds,ifold),:);
					trainidx{isubj} = reshape(trainidx{isubj},1,[]);
					
					if(config.used_data ~= 1)
						trainidx{isubj} = reduce_training_data(config.used_data, trainidx{isubj});
					end
					
					idx_lengths{isubj} = [length(trainidx{isubj}), length(testidx{isubj})];
				end
				assert(isequal(idx_lengths{:}) == 1); % check if all training/test size is the same for all subjects
				if ifold == 1
					fprintf('used data: %d of %d data points\n',...
						 idx_lengths{1}(1), numel(data_idcs{icolcond,idepthcond,1}(setdiff(1:config.nfolds,ifold),:)));
					config.ndata_points_orig = numel(data_idcs{icolcond,idepthcond,1}(setdiff(1:config.nfolds,ifold),:));
					config.ndata_points_reduced = idx_lengths{1}(1);
				end
				
%				[can_act_pts{icolcond, idepthcond, ifold},...
%					can_cmpts{icolcond, idepthcond, ifold},...
%					dirs{icolcond, idepthcond, ifold},...
%					scores{icolcond,idepthcond,ifold}] = apply_cca(trainidx, testidx, subject_data, config.nfactors);
					
%				[cisc(icolcond,idepthcond,ifold,:,:), cisc_ids(icolcond,idepthcond,ifold,:,:)] = ...
%					sequ_cisc(can_cmpts{icolcond, idepthcond, ifold});
					
				[can_act_pts,can_cmpts,dirs,scores{icolcond,idepthcond,ifold}] = ...
					apply_cca(trainidx, testidx, subject_data, config.nfactors);
				[cisc(icolcond,idepthcond,ifold,:,:), cisc_ids(icolcond,idepthcond,ifold,:,:)] = ...
					sequ_cisc(can_cmpts);
			end
		end
	end
	
	output_dir = fullfile(config.base_dir, [num2str(config.used_data*100), '_pcnt']);
	if exist(output_dir)~=7
		mkdir(output_dir);
	end
	
%	fprintf('\nCalculating average activation patterns.\n');
%	av_can_act_pts = average_pattern_fix_condition(can_act_pts);
%	
%	fprintf('\nSaving results.\n');
%	save(fullfile(output_dir, 'cca_output.mat'),...
%		'can_act_pts', 'can_cmpts', 'dirs', 'cisc', 'cisc_ids');
%	save(fullfile(output_dir, 'average_patterns.mat'), 'av_can_act_pts');
%	save(fullfile(output_dir, 'config.mat'), 'config');
	
	% preparing output
%	output.av_can_act_pts = av_can_act_pts;
%	output.can_act_pts = can_act_pts;
	output.cisc = cisc;
	output.cisc_ids = cisc_ids;
	output.scores = scores;
end

function new_idcs = reduce_training_data(ratio, train_idcs)
	splitpoint = round(ratio*length(train_idcs));
	assert(splitpoint < length(train_idcs) && splitpoint > 0);
	new_idcs = train_idcs(1:splitpoint);
end
