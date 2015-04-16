function fix_movie_visualise_fold_patterns(subject_data, patterns, output_dir, exp_name, num_factors)
	for ifact = 1:num_factors
		image_container = {};
		for isubj = 1:length(patterns)
			% put pattern into fully-sized volume
			mask = subject_data{isubj}.gmask;
			pattern = patterns{isubj};
			vol = ones(size(mask)) * min(pattern(:,ifact));
			vol(mask) = pattern(:,ifact);
		
			% position volume on canvas
			imgs_per_row = ceil(sqrt(length(patterns)));
			col_idx = mod(isubj,imgs_per_row);
			if col_idx == 0
				row_idx = fix(isubj/imgs_per_row);
				col_idx = imgs_per_row;
			else
				row_idx = fix(isubj/imgs_per_row)+1;
			end
			image_container{row_idx, col_idx} = flat_image(vol);
		end
		% plot and save
		save_path = fullfile(output_dir, [exp_name, 'f', num2str(ifact)]);
		plot_container(image_container, save_path)
	end
end

function plot_container(container, save_path)
	clf;
	[num_rows, num_cols] = size(container);
	handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.4], [0.6 0.7], [0.8 0.3], 'centimeters');
	
	for irow = 1:num_rows
		for icol = 1:num_cols
			ax_idx = (irow-1) * num_cols + icol;
			axes(handles(ax_idx));
			set(gcf, 'Visible', 'off')
			imagesc(rot90(container{irow,icol}));
		end
	end
	
	set(handles(1:end), 'XTick', []);
	set(handles(1:end), 'YTick', []);
	
	print(gcf, [save_path, '.png'], '-dpng', '-r500', '-opengl');
end

function image = flat_image(vol)
	% change orientation to sagittal view
	vol = permute(vol, [2,1,3]);
	[a,b,c] = size(vol);
	nslices_per_axis = ceil(sqrt(a))-1;
	size_x = nslices_per_axis * b;
	size_y = nslices_per_axis * c;
	
	image = zeros(size_x, size_y);
	slice_idx = 1;
	for irow = 1:nslices_per_axis
		for icol = 1:nslices_per_axis
			if slice_idx < a
				slice = squeeze(vol(slice_idx,:,:));
				row_idcs = [(irow-1)*b+1 : irow*b];
				col_idcs = [(icol-1)*c+1 : icol*c];
				
				image(row_idcs, col_idcs) = slice;
			end
			slice_idx = slice_idx+1;
		end
	end
end
