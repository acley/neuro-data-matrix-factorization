function fix_movie_loo_CV(config, subject_data)
	
	data_percentages = [1.0, 0.99, 0.95, 0.9, 0.75, 0.5];
	for imovie = 1:3
		% separate time slices of each movie for each subject
		fprintf('Extracting time slices of movie %d.\n', imovie);
		for isubj = 1:length(subject_data)
			X = subject_data{isubj};
			
			% extract time slices of current movie
			idx = find(X.conditions(:,1) == imovie);
			
			% shuffle slices
			idx = idx(randperm(length(idx)));
			
			data{imovie,isubj} = idx;
			
			num_data_points{isubj} = length(idx);
		end
		% extract the number of data points. should be the same for each subject
		assert(isequal(num_data_points{:}) == 1)
		num_data_points = num_data_points{1}
		
		reduced_data = floor(repmat(num_data_points, [1,length(data_percentages)]) .* data_percentages)
		
		pause
		
%		for ipcnt = 1:length(data_percentages)
%			for ifold = 1:num_data_points
%				fprintf('\tProcessing fold %d of %d.\n', ifold, num_data_points);
%				for isubj = 1:length(subject_data)
%					% split into training and test data
%					testidx{isubj} = data{imovie,isubj}(ifold);
%					trainidx{isubj} = data{imovie,isubj}(setdiff(1:num_data_points,ifold));
%					
%					% reduce data
%					new_length = floor(length(trainidx{isubj} * data_percentages(ipcnt));
%					rand_idx = randperm(new_length);
%					trainidx{isubj} = trainidx{isubj}(rand_idx(1:new_length));
%				end
%		
%				% apply CCA
%				[can_act_pts, can_cmpts, dirs, scores{ipcnt,imovie,ifold}] = ...
%					apply_cca(trainidx, testidx, subject_data, config.nfactors);
%				
%				[cisc(imovie, ifold, :, :), cisc_ids(imovie, ifold, :, :)] = ...
%						sequ_cisc(can_cmpts);
%			
%				% pattern visualisation		
%%				output_dir = fullfile(config.base_dir, 'pattern_visualisations');
%%				if exist(output_dir) ~= 7
%%					mkdir(output_dir)
%%				end
%%				exp_name = ['Movie',num2str(imovie),'-Fold',num2str(ifold),'-'];
%%				num_factors = 2;
%%					fix_movie_visualise_fold_patterns(subject_data, can_act_pts, output_dir, exp_name,num_factors);
%			end
%		end
%	end
%	
%	output.cisc = cisc;
%	output.scores = scores;
	output = [];
end
