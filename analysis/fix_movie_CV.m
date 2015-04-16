function fix_movie_CV(config, subject_data)

	for imovie = 1:3
		% separate time slices of each movie for each subject
		fprintf('Extracting time slices of movie %d.\n', imovie);
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract time slices of current movie
			idx = find(X.conditions(:,1) == imovie);
			
			% shuffle slices
			idx = idx(randperm(length(idx)));
			
			data{isubj} = idx;
			Xtrain{isubj} = X.K(data{isubj}, data{isubj});
		end
		
		[score{imovie}, directions, ~] = cca(Xtrain, config.nfactors);
		if (sum(score{imovie}<0) ~= 0)
			score
		end
		assert((sum(score{imovie}<0) ~= 0) == 0);
		
		% activation patterns
		for isubj = 1:length(subject_data)
			% can_comp: transpose (txf) because of cisc_cv requirement)
			canonical_components{isubj} = (directions{isubj}' * Xtrain{isubj})';
			X = subject_data{isubj};
			activation_patterns{isubj} = ...
				(canonical_components{isubj}' * X.dat(:,data{isubj})')';
		end
		score{imovie}
end
