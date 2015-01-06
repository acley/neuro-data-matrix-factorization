function gen_nsynth_pattern_blocks(nsynth_nifti_dir, nsynth_pattern_dir)
	tmp = dir(fullfile(nsynth_nifti_dir, '*.nii'));
	features = {tmp(:).name};
	num_features = size(features,2);
	
	% get volume information to init mat
	tmp_vol = spm_vol(fullfile(nsynth_nifti_dir, features{1}));
	tmp_nii = spm_read_vols(tmp_vol);
	voxel_space = size(tmp_nii);
	
	fprintf('Begin Loading Nifti images\n');
	batch_size = 100;
	dat = [];
	batch_counter = 0;
	for ifeature = 1:num_features
	
		if mod(ifeature,batch_size) == 0
			% store on disk & reset container
			fprintf('Saving batch %d (%d of %d features processed)\n', batch_counter, ifeature, num_features);
			save(fullfile(nsynth_pattern_dir, ['nsynth_batch_', num2str(batch_counter)]), 'dat');
			dat = [];
			batch_counter = batch_counter+1;
		end
		
		feature_dat = spm_read_vols(spm_vol(fullfile(nsynth_nifti_dir, features{ifeature})));
		feature_dat = reshape(feature_dat, numel(feature_dat), []);
		dat = [dat, feature_dat];
	end
	
	% save remaining features
	save(fullfile(nsynth_pattern_dir, ['nsynth_batch_', num2str(batch_counter)]), 'dat');
end
