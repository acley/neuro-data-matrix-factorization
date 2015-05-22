function sanity_check(config, subject_data)
	nsubjects = 3;
	%~ subject_data = load_subject_data(config.subject_data_dir, config.kernel, nsubjects);
	%~ [idcs, labels] = fix_conditions_idcs(subject_data, config.nfolds);
	%~ [idcs, labels] = fix_conditions_sorted_folds(subject_data);
	%~ [idcs, labels] = fix_single_condition_idcs(config, subject_data);
	%~ [idcs, labels] = fix_movie_idcs(subject_data, config.nfolds);
	[idcs, labels] = fix_conditions_sorted_folds(subject_data);
	[ridcs, rlabels] = add_random_idcs(subject_data, idcs, labels);
	[ciscs, scores, valid_folds] = CCA_CV(config, subject_data, ridcs, rlabels);
	row_labels = rlabels;
	col_labels = generate_column_labels(config.used_data, ridcs);
	score_visualisation(scores, valid_folds, row_labels, col_labels, config.base_dir);
	cisc_visualisation(ciscs, valid_folds, row_labels, col_labels, config.base_dir);
end
