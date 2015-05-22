function cisc_visualisation(ciscs, valid_folds, row_labels, column_labels, output_dir)
	clf;
	
	% cond, ratio, fold, pair, factors
	
	% average_over folds and pairs
	[mean_ciscs, std_ciscs] = analyse_ciscs(ciscs, valid_folds);
	%~ mean_ciscs = squeeze(mean(mean(ciscs,4),3)); % mean over pairs, then over folds
	%~ std_ciscs = squeeze(std(mean(ciscs,4),0,3)); % mean over pairs, then std over folds
	
	nrows = size(ciscs,1); % conditions 
	ncols = size(ciscs,2); % data_ratios
	nfactors = size(ciscs,5);
	ha = tightPlots(nrows, ncols, 15, [1.5,1], [0.4 0.1], [1.5 0.7], [1.5 1.5], 'centimeters');
	%~ ha = tight_subplot(nrows,ncols,[.03 .01],[.7 .7],[.01 .01])
	for irow = 1:nrows % loop over data ratios
	
		% find min/max values for axis limnit of this row
		row_mean = squeeze(mean_ciscs(irow,:,:));
		row_std = squeeze(std_ciscs(irow,:,:));
		row_max = max(max(row_mean + row_std));
		row_min = min(min(row_mean - row_std));
		minmax_rounded = [floor(row_min*100)/100, ceil(row_max*100)/100];
		
		for icol = 1:ncols % loop over classes/conditions
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
				%~ ticks = minmax_rounded;
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
	
	print(gcf, fullfile(output_dir, 'ciscs.eps'), '-depsc2', '-painters', '-loose');
end

