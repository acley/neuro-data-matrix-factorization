function visualize_patterns()
	set_paths;
	
	load mri;
	masks = load_masks(subject_data_dir);
	
	percentages = dir(fullfile(cca_output_dir, '*percent'));
	for ipcnt = 1:length(percentages)
		input_dir = fullfile(cca_output_dir, percentages(ipcnt).name);
		output_dir = fullfile(cca_visualisation_dir, percentages(ipcnt).name);
		if exist(output_dir) ~= 7
			mkdir(output_dir);
		end
		
		training_conditions = dir(fullfile(input_dir, '*.mat'));
		for icond = 1:length(training_conditions)
			data = load(fullfile(input_dir, training_conditions(icond).name),...
						'canonical_activation_patterns', 'directions');
			patterns = data.canonical_activation_patterns;
			weights = data.directions;
			
			for isubj = 1:length(patterns)
				mask = masks{isubj};
				
				for ifact = 1:4
					vol = ones(size(mask)) * min(patterns{isubj}(:,ifact));
					vol(mask) = patterns{isubj}(:,ifact);
					
					% change orientation for sagittal view
					vol = permute(vol, [2, 1, 3]);
					[a, b, c] = size(vol);
					num_images_per_axis = ceil(sqrt(a)) - 1;
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

				subj_name = ['Subject ', num2str(isubj)];
				exp_name = regexprep(training_conditions(icond).name, '_', ' ');
				exp_name = regexprep(exp_name, '.mat', '');

				plot_factors_of_subject(exp_name, subj_name, output_dir, container, map);
		
%				clf;
%				hold on
%				title(name)
%				colormap(map);
%				colorbar()
%				imagesc(container{1}');
%				axis image
%				set(gca, 'XTick', []);
%				set(gca, 'YTick', []);
%				hold off
%				print('-dpng', '-r600', fullfile(output_dir, [name, 'single.png']));
%				print('-depsc', fullfile(output_dir, [name, 'single.eps']));
			end
		end
	end
end

function plot_factors_of_subject(experiment_name, subject_id, output_dir, data, map)
	clf;
	figure('Visible','Off');
	for ifact = 1:4
		subplot(2,2,ifact);
		hold on
		subp_title = ['Factor ', num2str(ifact)];
		title(subp_title);
		colormap(map);
		colorbar()
		imagesc(data{ifact}');
		axis image
		set(gca, 'XTick', []);
		set(gca, 'YTick', []);
		hold off
	end	
%	set(gcf,'NextPlot','add');
%	axes;
%	h = title('whatever_your_title');
%	set(gca,'Visible','off');
%	set(h,'Visible','on');
%	suptitle(main_title);
%	print('-depsc', fullfile(output_dir, [experiment_name, ': ', subject_id, '.eps']));
%	print('-dpng', '-r600', fullfile(output_dir, [experiment_name, ': ', subject_id, '.png']));
	print('-dpng', fullfile(output_dir, [experiment_name, ': ', subject_id, '.png']));
end

function masks = load_masks(subject_data_dir)
	subjects = dir(fullfile(subject_data_dir, '*.mat'));
	for isubj = 1:length(subjects)
		tmp = load(fullfile(subject_data_dir, subjects(isubj).name), 'gmask');
		masks{isubj} = tmp.gmask;
	end
end
