function [idcs, labels] = add_random_idcs(subject_data, idcs, labels)
	nfolds = size(idcs,3);
	ndata_points = size(idcs,4) * nfolds;
	[ridcs, rlabel] = random_idcs(subject_data, nfolds, ndata_points);
	idcs(end+1,:,:,:) = ridcs;
	labels{end+1} = rlabel;
end
