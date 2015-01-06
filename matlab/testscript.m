Configuration;

path1 = config.cca_output_fixed_conditions_dir;
path2 = config.cca_output_fixed_movie_dir;

experiments = dir(fullfile(path2, '*.mat'));
experiments = {experiments(:).name};
num_experiments = size(experiments,2);

for iexp = 1:num_experiments
	X = load(fullfile(path2, experiments{iexp}));
	c_lin{iexp} = X.correlations_lin;
	c_gauss{iexp} = X.correlations_gauss;
	pat_lin{iexp} = X.activation_pattern_lin;
	pat_gauss{iexp} = X.activation_pattern_gauss;
end
