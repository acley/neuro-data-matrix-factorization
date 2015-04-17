function fix_movie_visualise_cisc2(config, ciscs)

	clf;
	
	% prepare handles for the subplots
	num_rows = 4; % 1 per movie, 1 for the average
	num_cols = size(ciscs,1);
	handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.8], [1.5 0.7], [1.5 0.3], 'centimeters');
	
	for icol = 1:num_cols
		for irow = 1:size(ciscs,2)
			% calculate mean an variance
			movie_cisc = squeeze(ciscs(icol,irow,:,:,:));
			mu = squeeze(mean(movie_cisc,2));
			mu_per_fold = mean(mu,1);
			var = squeeze(std(movie_cisc,0,2));
			var_per_fold = mean(var,1);
			
			% prepare axes
			ax_idx = (irow-1)*num_cols + icol;
			axes(handles(ax_idx));
			set(gcf, 'Visible', 'Off');
			
			% plot
			errorbar(mu_per_fold, var_per_fold, 'rx');
			num_factors = config.nfactors;
			xlim([0,num_factors+1]);
			ylim([0,1]);
		end
	end
	
	% clear ticks
	set(handles(1:end), 'fontname', 'Times', 'fontsize', 10);
	set(handles(1:end), 'Xtick', [], 'Ytick', [])
	
	% add legend and ytick to first colum
	for irow = 1:num_rows-1
		ax_idx = (irow-1) * num_cols + 1;
		movies = {'Cherryblossom','Deepsea','Rallyekorea'};
		ylabel(handles(ax_idx), movies{irow});
		set(handles(ax_idx), 'Ytick', [0,0.5,1]);
	end
	
	% column titles
	data_reductions = [1.0,0.99,0.95,0.9,0.75,0.5];
	data_points = floor(repmat(160, [1,length(data_reductions)]) .* data_reductions);
	for icol = 1:num_cols
		title_str = [num2str(data_reductions(icol)), '% of Data'];
		axes(handles(icol));
		title(title_str);
		set(gcf, 'Visible', 'Off');
	end
	
	% save
%	print(gcf, fullfile(config.base_dir, 'cisc.eps'), '-depsc2', '-painters', '-loose');
	print(gcf, fullfile(config.base_dir, 'cisc.png'), '-dpng', '-r500', '-opengl');
end


