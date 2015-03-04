function visualise_ciscs(config)
	base_dir = config.base_dir;
	subject_data_dir = config.subject_data_dir;
	
	experiments = dir(fullfile(base_dir, '*percent*'));
	for iexp = 1:length(experiments)
		cca_output = load(fullfile(base_dir, experiments(iexp).name, 'cca_output.mat'), 'cisc', 'cisc_ids');
		cisc = cca_output.cisc;
		
		clf;
		num_rows = size(cisc,1) * size(cisc,2);
		num_cols = size(cisc,3);
		handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.8], [1.5 0.7], [1.5 0.3], 'centimeters');
		ax_counter = 1;
		for icolcond = 1:size(cisc,1)
			for idepthcond = 1:size(cisc,2)
				for ifold = 1:size(cisc,3)
					fold_cisc = squeeze(cisc(icolcond,idepthcond,ifold,:,:));
					axes(handles(ax_counter));
					set(gcf, 'Visible', 'off');
					errorbar(mean(fold_cisc), std(fold_cisc), 'rx');
					xlim([0,11]);
					ylim([0,1]);
					if ifold ~= 1
						set(gca, 'YTick', []);
					else
						label = viewing_condition(icolcond, idepthcond);
						ylabel(label);
					end
					ax_counter = ax_counter + 1;
				end
			end
		end
		
		col_titles = {'Fold 1', 'Fold 2', 'Fold 3'};
		for ititle = 1:num_cols
			axes(handles(ititle)); title(col_titles{ititle});
			set(gcf, 'Visible', 'off')
		end
		
		set(handles(1:end), 'fontname', 'Times', 'fontsize', 10);
		set(handles(1:end), 'XTick', []);
		set(handles(end-2:end), 'XTick', 1:10);
		for iaxis = 0:2
			xlabel(handles(end-iaxis), 'Factors');
		end
		
		output_dir = fullfile(base_dir, experiments(iexp).name, 'cisc_visualisations');
		if exist(output_dir) ~= 7
			mkdir(output_dir)
		end
		print(gcf, fullfile(output_dir, 'cisc_vis.eps'), '-depsc2', '-painters', '-loose');
%	print(gcf, [save_path, '.png'], '-dpng', '-r1000', '-opengl');
	end
end

function viewing_condition = viewing_condition(colcond,depthcond)
	color_conds = {'b&w', 'color'};
	depth_conds = {'2D', '3D'};
	movie_conds = {'Cherryblossom','Deepsea','Rallyekorea'};
	viewing_condition = [color_conds{colcond}, ' ', depth_conds{depthcond}];
end
