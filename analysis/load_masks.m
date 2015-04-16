function masks = load_masks(subject_data_dir)
	subjects = dir(fullfile(subject_data_dir, '*.mat'));
	for isubj = 1:length(subjects)
		tmp = load(fullfile(subject_data_dir, subjects(isubj).name), 'gmask');
		masks{isubj} = tmp.gmask;
	end
end
