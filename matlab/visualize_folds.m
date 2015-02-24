function visualize_folds()

	set_paths;
	
	masks = load_masks(subject_data_dir);
	load mri %fmri colormap
	
	percentages = dir(fullfile(cca_output_dir, '*percent'));
	for ipcnt = 1:1%length(percentages)
		fprintf('Processing the runs using %s of the availible training data.\n',...
				percentages(ipcnt).name);
		pcnt_dir = fullfile(cca_output_dir, percentages(ipcnt).name);
		viewing_conditions_split = load_activation_patterns(pcnt_dir);
		viewing_conditions_grouped = group_conditions(viewing_conditions_split);
		output_dir = fullfile(cca_visualisation_dir, percentages(ipcnt).name);
		if exist(output_dir) ~= 7
			mkdir(output_dir);
		end
		
		pepare_plot_data(viewing_conditions_grouped, masks, map, output_dir);
	end
end

function pepare_plot_data(condition_groups, masks, map, output_dir)
	num_groups = length(condition_groups.data);
	for igroup = 1:num_groups
		fprintf('%s\n', condition_groups.names{igroup});
		condition_name = condition_groups.names{igroup};
		condition_folds = condition_groups.data{igroup};
		num_subjects = length(condition_folds{1});
		for isubj = 1:num_subjects
			fprintf('\tSubject %s\n', num2str(isubj));
			mask = masks{isubj};
			num_folds = length(condition_folds);
			
			for ifold = 1:num_folds
				pattern = condition_folds{ifold}{isubj};
				fprintf('\t\tFold %s\n', num2str(ifold));
				for ifact = 1:3
					vol = ones(size(mask)) * min(pattern(:,ifact));
					vol(mask) = pattern(:,ifact);
					
					% change orientation to sagittal view
					vol = permute(vol, [2,1,3]);
					[a,b,c] = size(vol);
					num_images_per_axis = ceil(sqrt(a))-1;
					size_x = num_images_per_axis * b;
					size_y = num_images_per_axis * c;
					
%					container{ifact} = zeros(size_x, size_y);
					slice_idx = 1;
					for irow = 1:num_images_per_axis
						for icol = 1:num_images_per_axis
							if slice_idx < a
								sub_img = squeeze(vol(slice_idx,:,:));
								row_idcs = [(irow-1)*b+1 : irow*b];
								col_idcs = [(icol-1)*c+1 : icol*c];
								
								container{ifold}{ifact}(row_idcs, col_idcs) = sub_img;
							end
							slice_idx = slice_idx+1;
						end
					end
				end
			end
			
			col_titles = {'Factor 1', 'Factor 2', 'Factor 3'};
			row_titles = {'Fold 1', 'Fold 2', 'Fold 3'};
			save_path = fullfile(output_dir, [condition_name, ' - Subject ', num2str(isubj)]);
			apply_plot(container, map, col_titles, row_titles, save_path);
			pause
			
%			experiment_name = [condition_name, ': Subject', num2str(isubj)];
%			print('-dpng', '-r600', fullfile(output_dir, [experiment_name, '.png']));
		end
	end	
end

function apply_plot(data, map, column_titles, row_titles, save_path)
	clf;
	num_rows = length(data);
	num_cols = length(data{1});
	handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.4], [0.6 0.7], [0.8 0.3], 'centimeters');
	for irow = 1:num_rows
		for icol = 1:num_cols
			ax_idx = (irow-1) * num_cols + icol;
			axes(handles(ax_idx));
%			colormap(map);
			set(gcf, 'Visible', 'off')
			imagesc(rot90(data{irow}{icol}));
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
%	print(gcf, 'Example2.pdf', '-dpdf', '-painters', '-loose');
%	print(gcf, 'Example2.png', '-dpng', '-r1000', '-opengl');
end

function viewing_condition_groups = group_conditions(conditions)
	viewing_condition_groups.data = {{},{},{},{}};
	viewing_condition_groups.names = {'color_2D', 'color_3D', 'b&w_2D', 'b&w_3D'};
	for icond = 1:length(conditions)
		condition = conditions{icond};
		for ibin = 1:length(viewing_condition_groups.names)
			if ~isempty(strfind(condition.name, viewing_condition_groups.names{ibin}))
				viewing_condition_groups.data{ibin}{end+1} = condition.canonical_activation_patterns;
			end
		end
	end
end

function conditions = load_activation_patterns(input_dir)
	viewing_conditions = dir(fullfile(input_dir, '*.mat'));
	conditions = {};
	for icond = 1:length(viewing_conditions)
		condition = load(fullfile(input_dir, viewing_conditions(icond).name), 'canonical_activation_patterns');
		condition.name = regexprep(viewing_conditions(icond).name, '.mat', '');
		conditions{end+1} = condition;
	end
end

function masks = load_masks(subject_data_dir)
	subjects = dir(fullfile(subject_data_dir, '*.mat'));
	for isubj = 1:length(subjects)
		tmp = load(fullfile(subject_data_dir, subjects(isubj).name), 'gmask');
		masks{isubj} = tmp.gmask;
	end
end
