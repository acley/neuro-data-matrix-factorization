function [ciscs, scores, valid_folds] = CCA_CV(config, subject_data, idcs, labels)
	nfolds = size(idcs,3);
	nsubjs = size(idcs,2);
	nfactors = config.nfactors;
	data_reductions = config.used_data;
	
	for icond = 1:length(labels)
		fprintf('%s: \n', labels{icond})
		for iratio = 1:length(data_reductions)
			fprintf('\tdata reduction: %d%%\n', data_reductions(iratio)*100);
			for ifold = 1:nfolds
				fprintf('\t\tFold %d\n', ifold);
				% prepare training and test data
				for isubj = 1:nsubjs
					testidx{isubj} = squeeze(idcs(icond,isubj,ifold,:))';
					if nfolds == 1 % no test set! train on full data
						trainidx{isubj} = testidx{isubj};
					else
						trainidx{isubj} = squeeze(idcs(icond,isubj,setdiff(1:nfolds,ifold),:));
						trainidx{isubj} = reshape(trainidx{isubj},1,[]);
					end
				
					% reduce training data according to data_reductions
					new_length = floor(length(trainidx{isubj})*data_reductions(iratio));
					trainidx{isubj} = trainidx{isubj}(1:new_length);
				end
			
				% CCA and cisc
				[patterns,components,dirs,scores(icond,iratio,ifold,:)] = ...
					apply_cca(trainidx, testidx, subject_data, nfactors);
				[ciscs(icond,iratio,ifold,:,:), cisc_ids(icond,iratio,ifold,:,:)] = ...
					sequ_cisc(components);
					
				% collect valid folds without numerical error
				valid_folds(icond,iratio,ifold) = scores(icond,iratio,ifold,1) > 0;
		end
	end
end
