function av_can_act_pts = average_pattern_over_folds(patterns, experiment_type)
	if strcmp(experiment_type, 'fixed_viewing_condition')
		av_can_act_pts = average_pattern_fixed_viewing_conditions(patterns);
	elseif strcmp(experiment_type, 'fixed_movie')
		av_can_act_pts = average_pattern_fixed_movie(patterns);
	end
end

function av_can_act_pts = average_pattern_fixed_viewing_condition(patterns)
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

function av_can_act_pts = average_pattern_fixed_movie(patterns)
	for imovie = 1:size(patterns,1)
		av_pat = patterns{imovie,1};
		for ifold = 2:size(patterns,2)
			ipattern = patterns{imovie,ifold};
			for isubj = 1:length(ipattern)
				av_pat{isubj} = ((ifold-1)/ifold) * av_pat{isubj} + (1/ifold) * ipattern{isubj};
			end
		end
		
	av_can_act_pts{imovie} = av_pat;
	end
end
