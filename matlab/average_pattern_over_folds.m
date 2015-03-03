function av_can_act_pts = average_pattern_over_folds(patterns)
	for icolcond = 1:size(patterns,1);
		for idepthcond = 1:size(patterns,2)
			% initiate average pattern
			av_pat = patterns{icolcond,idepthcond,1};
			for ifold = 2:size(patterns,3)
				data = patterns{icolcond,idepthcond,ifold};
				for isubj = 1:length(data)
					av_pat{isubj} = ((ifold-1)/ifold) * av_pat{isubj} + (1/ifold) * data{isubj};
				end
			end
			av_can_act_pts{icolcond, idepthcond} = av_pat;
		end
	end
end
