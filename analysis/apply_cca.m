function [activation_patterns, canonical_components, directions, score] = ...
				apply_cca(trainidcs, testidcs, subject_data, ncomp)
	
	assert(length(trainidcs) == length(testidcs));
	
	[Xtrain, Xtest] = prepare_data(trainidcs, testidcs, subject_data);
	
	% find canonical components
	[score,directions,~] = cca(Xtrain,ncomp);
	if (sum(score<0) ~= 0)
		idx = find(score<0);
		for i = 1:length(idx)
			directions{idx(i)} = directions{idx(i)}*-1;
		end
		score = abs(score)
	end
%	assert(sum(score<0) == 0); % make sure no directions have to be inverted
   
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
