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
		plot_groups(viewing_conditions_grouped, masks, map, output_dir);
	end
end

function plot_groups(condition_groups, masks, map, output_dir)
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
			
			clf;
			figure('Visible','Off');
			
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
					
					container{ifact} = zeros(size_x, size_y);
					slice_idx = 1;
					for irow = 1:num_images_per_axis
						for icol = 1:num_images_per_axis
							if slice_idx < a
								sub_img = squeeze(vol(slice_idx,:,:));
								row_idcs = [(irow-1)*b+1 : irow*b];
								col_idcs = [(icol-1)*c+1 : icol*c];
								
								container{ifact}(row_idcs, col_idcs) = sub_img;
							end
							slice_idx = slice_idx+1;
						end
					end
				end
				
				add_row_to_subplot(container, map, ifold);
%				set(gcf, 'Visible', 'On');
%				pause
				
				% create visualisation container
				% add subplot (1 row per fold, 3 columns for 3 factors)
			end
			
			experiment_name = [condition_name, ': Subject', num2str(isubj)];
			print('-dpng', '-r600', fullfile(output_dir, [experiment_name, '.png']));
		end
	end
end

function add_row_to_subplot(container, map, row_idx)
	for ifact = 1:3
%		subplot(3,3,(row_idx-1)*3 + ifact);
		subaxis(3,3,(row_idx-1)*3 + ifact, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
		hold on
		subp_title = ['Factor ', num2str(ifact)];
		title(subp_title);
%		colormap(map);
%		colorbar()
		imagesc(container{ifact}');
%		axis image
		axis off
%		set(gca,'Position',[0 0 1 1]) 
%		set(gca, 'XTick', []);
%		set(gca, 'YTick', []);
		
		hold off
	end	
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
