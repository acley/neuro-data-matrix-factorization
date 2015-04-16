function fix_movie_visualise_average_cisc(config, cisc)
	m = squeeze(mean(mean(c,3),2));
	s = squeeze(std(std(c,0,3),0,2));

end
