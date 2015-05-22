function score_visualisation(scores, valid_folds, row_labels, column_labels, output_dir)
	clf;
	% cond, ratio, fold, factors
	
	% average_over folds
	%~ mean_scores = squeeze(mean(scores,3));
	%~ std_scores = squeeze(std(scores,0,3));
	[mean_scores, std_scores] = analyse_scores(scores, valid_folds);
		
	nrows = size(scores,1); % conditions
	ncols = size(scores,2); % data ratios
	nfactors = size(scores,4);
	ha = tightPlots(nrows, ncols, 15, [1.5,1], [0.4 0.1], [1.5 0.7], [1.5 0.3], 'centimeters');
	for irow = 1:nrows % loop over conditions
	
		% find min/max values for axis limnit of this row
		row_mean = squeeze(mean_scores(irow,:,:));
		row_std = squeeze(std_scores(irow,:,:));
		row_max = max(max(row_mean + row_std));
		row_min = min(min(row_mean - row_std));
		minmax_rounded = [floor(row_min*100)/100, ceil(row_max*100)/100];
		if diff(minmax_rounded) == 0
			minmax_rounded = [0,1];
		end
		
		for icol = 1:ncols % loop over data ratios
			% select axis
			ax_idx = (irow-1) * ncols + icol;
			axes(ha(ax_idx));
			
			% plot
			errorbar([1:nfactors], row_mean(icol,:), row_std(icol,:), 'rx');
			ylim(minmax_rounded);
			
			% ticks and labels
			set(ha(ax_idx), 'Xtick', [], 'Ytick', []);
			if icol == 1
				ylabel(row_labels{irow});
				ticks = sort(unique([minmax_rounded,mean(minmax_rounded)]));
				set(ha(ax_idx), 'Ytick', ticks);
			end
			if irow == 1
				title(column_labels{icol});
			end
			if irow == nrows
				set(ha(ax_idx), 'Xtick', [1:nfactors]);
				xlabel('Factors');
			end
			set(gcf, 'Visible', 'Off');
		end
	end
	
	print(gcf, fullfile(output_dir, 'scores.eps'), '-depsc2', '-painters', '-loose');
end


