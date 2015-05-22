function labels = generate_column_labels(ratios,idcs)
	for iratio = 1:length(ratios)
		[~, ~, nfolds, fold_size] = size(idcs);
		num_training_points = max(1,nfolds-1) * fold_size;
		reduced_training_points = floor(num_training_points * ratios(iratio));
		str = [num2str(reduced_training_points), ' pts: ', num2str(ratios(iratio)*100), '%'];
		labels{iratio} = str;
	end
end
