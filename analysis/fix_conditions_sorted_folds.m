function [idcs, labels] = fix_conditions_sorted_folds(subject_data)
	TR = 3;
	maxmovs = 3;
	for icolcond = 1:2
		for idepthcond = 1:2
			for isubj = 1:length(subject_data)
				X = subject_data{isubj};
				
				% extract data points of current viewing condition
				idx = find(X.conditions(:,1)>0 & ...
							X.conditions(:,1)<=3 & ...
							X.conditions(:,2)==icolcond-1 & ...
							X.conditions(:,3)==idepthcond-1);
				
				% sort by movie id			
				[~,sortidx] = sort(X.conditions(idx,1));
				idx = idx(sortidx);
				idx = reshape(idx,length(idx)/maxmovs,maxmovs)';
				
				cond_idx = (icolcond-1)*2 + idepthcond;
				idcs(cond_idx, isubj, :, :) = idx;
			end
		end
	end
	labels = {'b&w - 2D', 'b&w - 3D', 'color - 2D', 'color - 3D'};
end
