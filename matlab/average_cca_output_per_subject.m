function average_cca_output_per_subject()
	set_paths;

	percentages = dir(fullfile(cca_output_dir, '*percent'));
	for ipcnt = 1:1%length(percentages)
		fprintf('Processing the runs using %s of the availible training data.\n',...
				percentages(ipcnt).name);
		pcnt_dir = fullfile(cca_output_dir, percentages(ipcnt).name);
		viewing_conditions_split = load_activation_patterns(pcnt_dir);
		viewing_conditions_grouped = group_conditions(viewing_conditions_split);
		average_over_groups(viewing_conditions_grouped);
	end
end

function average_over_groups(condition_groups)
	for igroup = 1:length(condition_groups.names)
		condition_name = condition_groups.names{igroup};
		condition_folds = condition_groups.data{igroup};
		
		average_patterns = condition_folds{1};
		for isubj = 1:length(average_patterns)
			for ifold = 2:length(condition_folds)
				fold = condition_folds{ifold};
				average_patterns{isubj} = ...
					((ifold-1)/ifold) * average_patterns{isubj} + (1/ifold) * fold{isubj};
			end
		end
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
