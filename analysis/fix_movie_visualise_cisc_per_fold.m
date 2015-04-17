function fix_movie_visualise_cisc_per_fold(config, cisc)
%function fix_movie_visualise_cisc_per_fold(cisc, output_dir)
	clf;
	
	num_rows = size(cisc,1); % one row per movie
	num_cols = size(cisc,2); % one column per fold plus one average
	
	handles = tightPlots(num_rows, num_cols, 15, [1 1], [0.4 0.8], [1.5 0.7], [1.5 0.3], 'centimeters');
	for imovie = 1:num_rows
		for ifold = 1:num_cols
			% extract cisc
			fold_cisc = squeeze(cisc(imovie,ifold,:,:));
			
			% prepare handle for the current plot
			axes_id = (imovie-1)*num_cols + ifold;
			axes(handles(axes_id));
			set(gcf, 'Visible', 'Off');
			
			% plot
			errorbar(mean(fold_cisc), std(fold_cisc), 'rx');
			num_factors = min(config.nfactors,10);
			xlim([0,num_factors+1]);
			ylim([0,1]);
			
			% Yticks only for the first column, movie label for the first column
			if ifold ~= 1
				set(gca, 'YTick', []);
			else
				movies = {'Cherryblossom','Deepsea','Rallyekorea'};
				ylabel(movies{imovie});
			end
		end
	end
	
	% column titles
	for icol = 1:num_cols
		title_str = ['Fold ', num2str(icol)];
		axes(handles(icol));
		title(title_str);
		set(gcf, 'Visible', 'Off');
	end
	
	% Xticks on bottom row
	set(handles(1:end), 'fontname', 'Times', 'fontsize', 10);
	set(handles(1:end), 'XTick', []);
	for icol = 1:num_cols
		axes_id = (num_rows-1)*num_cols + icol;
		xlabel(handles(axes_id), 'Factors');
		num_factors = min(config.nfactors,10);
		set(handles(axes_id), 'Xtick', 1:num_factors);
	end
	
	% save
#	print(gcf, fullfile(config.base_dir, 'cisc_per_fold.eps'), '-depsc2', '-painters', '-loose');
	print(gcf, fullfile(config.base_dir, 'cisc_per_fold.png'), '-dpng', '-r500', '-opengl');
end
