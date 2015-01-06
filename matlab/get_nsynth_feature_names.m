function features = get_nsynth_feature_names(nsynth_nifti_dir)
	features = dir(fullfile(nsynth_nifti_dir, '*.nii'));
	features = {features(:).name};
	features = regexprep(features(:), '_pFgA_z.nii', '');
	features = regexprep(features(:), '_pAgF_z.nii', '');
end
