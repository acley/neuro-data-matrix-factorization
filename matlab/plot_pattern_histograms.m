function plot_canonical_pattern_histograms()
	set_paths;
	
	experiments = dir(fullfile(base_dir, '*percent*'));
	for iexp = 1:length(experiments)
		fprintf('Loading data for experiment %s\n', experiments(iexp).name);
		cca_output = load(fullfile(base_dir, experiments(iexp).name, 'cca_output.mat'), 'can_act_pts');
		can_act_pts = cca_output.can_act_pts;
		av_act_pts = load(fullfile(base_dir, experiments(iexp).name, 'average_patterns.mat'), 'av_can_act_pts');
		av_act_pts = av_act_pts.av_can_act_pts;
		
		output_dir = fullfile(base_dir, experiments(iexp).name, 'act_pattern_histograms');
		if exist(output_dir) ~= 7
			mkdir(output_dir);
		end
		
		prepare_plots(can_act_pts, av_act_pts, output_dir);
	end
end

function prepare_plots(can_act_pts, av_act_pts, output_dir)
	for icolcond = 1:size(can_act_pts,1)
		for idepthcond = 1:size(can_act_pts,2)
			for isubj = 1:length(av_act_pts{icolcond,idepthcond})
				clf;
				num_rows = size(can_act_pts,3)+1; % one for each fold plus average pattern
				num_cols = 3; % visualise the first 3 factors
				handles = tightPlots(num_rows, num_cols, 15, [1 1], [1.0 0.4], [0.6 0.7], [0.8 0.3], 'centimeters');
				for ifold = 1:size(can_act_pts,3)
					patterns = can_act_pts{icolcond,idepthcond,ifold}{isubj};
					for ifact = 1:num_cols
						ax_idx = (ifold-1) * num_cols + ifact;
						axes(handles(ax_idx));
						set(gcf, 'Visible', 'off');
						hist(patterns(:,ifact), 100);
					end
				end
				av_pat = av_act_pts{icolcond,idepthcond}{isubj};
				for ifact = 1:num_cols
					ax_idx = (num_rows-1)*num_cols + ifact;
					axes(handles(ax_idx));
					set(gcf, 'Visible', 'off');
					hist(av_pat(:,ifact), 100);
				end
				set(handles(1:end), 'fontname', 'Times', 'fontsize', 10);
				set(handles(1:end), 'YTick', []);
				
				% set col titles
				for ifact = 1:num_cols
					axes(handles(ifact)); title(['Factor ', num2str(ifact)]);
					set(gcf, 'Visible', 'off');
				end
				% set row titles
				row_titles = {'Act. Pat. Fold 1', 'Act. Pat. Fold 2', 'Act. Pat. Fold 3', 'Average Act. Pat.'};
				for irow = 1:num_rows
					ax_idx = (irow-1) * num_cols + 1;
					ylabel(handles(ax_idx), row_titles{irow});
					set(gcf, 'Visible', 'off');
				end
				
				save_path = fullfile(output_dir, [viewing_condition(icolcond,idepthcond), ' - Subject ', num2str(isubj)]);
				print(gcf, [save_path, '.eps'], '-depsc2', '-painters', '-loose');
%	print(gcf, [save_path, '.png'], '-dpng', '-r1000', '-opengl');
%				pause;
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
