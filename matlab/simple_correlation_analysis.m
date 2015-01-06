function simple_correlation_analysis_fixed_conditions(result_dir)
	% load data
	tmp = load(fullfile(result_dir, 'results.mat'));
	correlations_lin = tmp.correlations_lin;
	correlations_gauss = tmp.correlations_gauss;
	features = tmp.features;
	experiments = tmp.experiments;

	for iexp = 1:size(experiments,2)
		fprintf('Processing Experiment %d: %s\n', iexp, experiments{iexp});
		fprintf('\tRegular Correlation ...\n')
		% linear kernel
		correlation_lin = correlations_lin{iexp};
		num_factors = size(correlation_lin,1);
		[x_lin,y_lin] = sort(correlation_lin, 2, 'descend');
		labels1_lin = {features{y_lin(:,1)}};
		labels2_lin = {features{y_lin(:,2)}};
		labels3_lin = {features{y_lin(:,3)}};
		labels_lin = {labels1_lin, labels2_lin, labels3_lin};
		experiment_name = regexprep(experiments{iexp}, '.mat', '_lin_kernel');
		experiment_name = regexprep(experiment_name, '_', ' ');
		plotting(labels_lin,x_lin,experiment_name, result_dir);
		
		% gaussian kernel
		correlation_gauss = correlations_gauss{iexp};
		[x_gauss,y_gauss] = sort(correlation_gauss, 2, 'descend');
		labels1_gauss = {features{y_gauss(:,1)}};
		labels2_gauss = {features{y_gauss(:,2)}};
		labels3_gauss = {features{y_gauss(:,3)}};
		labels_gauss = {labels1_gauss, labels2_gauss, labels3_gauss};
		experiment_name = regexprep(experiments{iexp}, '.mat', '_gauss_kernel');
		experiment_name = regexprep(experiment_name, '_', ' ');
		plotting(labels_gauss,x_gauss,experiment_name, result_dir);
	end
end

function plotting(labels, x, experiment_name, save_path)
	num_factors = size(x,1);
	fig = figure('visible','off');
	hold on
	bar(1:num_factors, x(:,1:3))
	axis([0,num_factors+1, 0, 1]);
	set(gca, 'XTick', 1:num_factors);
	
	rot = 70;
	text1 = text([1:num_factors]-0.2, x(:,1), labels{1});
	set(text1, 'VerticalAlignment','bottom', 'FontSize',10, 'Color','b', 'Rotation', rot, 'Interpreter', 'LaTeX');
	text2 = text([1:num_factors], x(:,1), labels{2});
	set(text2, 'VerticalAlignment','bottom', 'FontSize',10, 'Color','b', 'Rotation', rot, 'Interpreter', 'LaTeX');
	text3 = text([1:num_factors]+0.2, x(:,1), labels{3});
	set(text3, 'VerticalAlignment','bottom', 'FontSize',10, 'Color','b', 'Rotation', rot, 'Interpreter', 'LaTeX');
	
	% remove file ending
%	experiment_name = regexprep(experiment_name, '.mat', '');
%	title(gca, regexprep(experiment_name, '_', ' '));
	title(gca, experiment_name);
	ylabel(gca, 'correlations');
	xlabel(gca, 'factors');
	hold off;
	filename = fullfile(save_path, regexprep(experiment_name, '.mat', ''));
	print(gcf, '-depsc', [filename, '.eps'])
%		print(gcf, '-dpdf', [filename, 'plot.pdf'])
%		print(gcf, '-dpng', [filename, '.png'])
end
