function random_visualise_cisc(config, cisc, output_dir)
	
	clf;
	
	num_cols = size(cisc,1);
	handles = tightPlots(1,num_cols, 15, [1 1], [0.4 0.8], [1.5 0.7], [1.5 0.3], 'centimeters');
	for ifold = 1:num_cols
		fold_cisc = squeeze(cisc(ifold,:,:));
		
		axes_id = ifold;
		axes(handles(axes_id));
		set(gcf, 'Visible', 'Off');
		
		% plot
		errorbar(mean(fold_cisc), std(fold_cisc), 'rx');
		num_factors = min(config.nfactors, 10);
		xlim([0,num_factors+1]);
		ylim([0,1]);
		
		% Yticks only for the first column, movie label for the first column
		if ifold ~= 1
			set(gca, 'YTick', []);
		else
			ylabel('Random Data Points');
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
	for icol = 1:num_cols
		axes_id = icol;
		xlabel(handles(axes_id), 'Factors');
		num_factors = min(config.nfactors,10);
		set(handles(axes_id), 'Xtick', 1:num_factors);
	end
	
	% save
	print(gcf, fullfile(output_dir, 'cisc_per_fold.eps'), '-depsc2', '-painters', '-loose');
	
end
