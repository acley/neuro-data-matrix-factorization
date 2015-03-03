function visualize_folds()
	set_paths;
	
	masks = load_masks(subject_data_dir);
	
	experiments = dir(fullfile(base_dir, '*percent*'));
	for iexp = 1:length(experiments)
		fprintf('Plotting folds using %s of the availible data.\n', experiments(iexp).name);
		cca_output = load(fullfile(base_dir, experiments(iexp).name, 'cca_output.mat'), 'can_act_pts');
		can_act_pts = cca_output.can_act_pts;
		av_act_pts = load(fullfile(base_dir, experiments(iexp).name, 'average_patterns.mat'), 'av_can_act_pts');
		av_act_pts = av_act_pts.av_can_act_pts;
		
		output_dir = fullfile(base_dir, experiments(iexp).name, 'fold_visualisations');
		if exist(output_dir) ~= 7
			mkdir(output_dir)
		end
		prepare_plots(can_act_pts, av_act_pts, masks, output_dir);
	end
end

function prepare_plots(can_act_pts, av_act_pts, masks, output_dir)
	for icolcond = 1:size(can_act_pts,1)
		for idepthcond = 1:size(can_act_pts,2)
			for isubj = 1:length(av_act_pts{icolcond,idepthcond})
				mask = masks{isubj};
				image_container = {};
				% 1 row for every fold ov the crossvalidation
				for ifold = 1:size(can_act_pts,3)
					pattern = can_act_pts{icolcond,idepthcond,ifold}{isubj};
					% 3 columns. one for each of the top 3 factors
					for ifact = 1:3
						vol = ones(size(mask)) * min(pattern(:,ifact));
						vol(mask) = pattern(:,ifact);
						
						image_container{ifold,ifact} = generate_flat_image(vol);
					end
				end
				% 1 row for the average pattern
				for ifact = 1:3
					pattern = av_act_pts{icolcond,idepthcond}{isubj};
					vol = ones(size(mask)) * min(pattern(:,ifact));
					vol(mask) = pattern(:,ifact);
					
					image_container{size(can_act_pts,3)+1,ifact} = generate_flat_image(vol);
				end
				col_titles = {'Factor 1', 'Factor 2', 'Factor 3'};
				row_titles = {'Act. Pat. Fold 1', 'Act. Pat. Fold 2', 'Act. Pat. Fold 3', 'Average Act. Pat.'};
				save_path = fullfile(output_dir, [viewing_condition(icolcond,idepthcond), ' - Subject ', num2str(isubj)]);
				print_plots(image_container, col_titles, row_titles, save_path);
			end
		end
	end
end

function viewing_condition = viewing_condition(colcond,depthcond)
	color_conds = {'b&w', 'color'};
	depth_conds = {'2D', '3D'};
	movie_conds = {'Cherryblossom','Deepsea','Rallyekorea'};
	viewing_condition = [color_conds{colcond}, ' ', depth_conds{depthcond}];
end

function flat_image = generate_flat_image(vol)
	% change orientation to sagittal view
	vol = permute(vol, [2,1,3]);
	[a,b,c] = size(vol);
	num_images_per_axis = ceil(sqrt(a))-1;
	size_x = num_images_per_axis * b;
	size_y = num_images_per_axis * c;
	
	flat_image = zeros(size_x, size_y);
	slice_idx = 1;
	for irow = 1:num_images_per_axis
		for icol = 1:num_images_per_axis
			if slice_idx < a
				sub_img = squeeze(vol(slice_idx,:,:));
				row_idcs = [(irow-1)*b+1 : irow*b];
				col_idcs = [(icol-1)*c+1 : icol*c];
				
				flat_image(row_idcs, col_idcs) = sub_img;
			end
			slice_idx = slice_idx+1;
		end
	end
end

function print_plots(data, column_titles, row_titles, save_path)
	clf;
	[num_rows, num_cols] = size(data);
	handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.4], [0.6 0.7], [0.8 0.3], 'centimeters');
	for irow = 1:num_rows
		for icol = 1:num_cols
			ax_idx = (irow-1) * num_cols + icol;
			axes(handles(ax_idx));
%			colormap(map);
			set(gcf, 'Visible', 'off')
			imagesc(rot90(data{irow,icol}));
		end
	end
	
	set(handles(1:end), 'fontname', 'Times', 'fontsize', 10);
	set(handles(1:end), 'XTick', []);
	set(handles(1:end), 'YTick', []);
	
	for ititle = 1:length(column_titles)
		axes(handles(ititle)); title(column_titles{ititle});
		set(gcf, 'Visible', 'off')
	end
	
	for ititle = 1:length(row_titles)
		ax_idx = (ititle-1) * num_cols + 1;
		ylabel(handles(ax_idx), row_titles{ititle});
		set(gcf, 'Visible', 'off');
	end
	
	print(gcf, [save_path, '.eps'], '-depsc2', '-painters', '-loose');
%	print(gcf, [save_path, '.pdf'], '-dpdf', '-painters', '-loose');
%	print(gcf, [save_path, '.png'], '-dpng', '-r1000', '-opengl');
end

function masks = load_masks(subject_data_dir)
	subjects = dir(fullfile(subject_data_dir, '*.mat'));
	for isubj = 1:length(subjects)
		tmp = load(fullfile(subject_data_dir, subjects(isubj).name), 'gmask');
		masks{isubj} = tmp.gmask;
	end
end
