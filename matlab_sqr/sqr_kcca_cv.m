function [brain_network, activation_pattern] = sqr_kcca_cv(X)
	sqr_set_paths

	matsavepath = '/home/achim/masterprojekt/data/sequrea/matexport'
	%load '/home/achim/masterprojekt/data/sequrea/matexport/subjdata.mat'

	ncomp = 20;
	maxmovs = 3;
	TR = 3;

	subjs = dir(fullfile(matsavepath,'SQR_*'));

	linearkernel = 0;

	% build kernel matrices if they aren't provided
	if nargin<1
		for isubj = 1:length(subjs)
			fprintf('Reading Subject %d\n',isubj)
			X{isubj} = load(fullfile(matsavepath,subjs(isubj).name));
			X{isubj}.dat = zscore(X{isubj}.dat')';
			if linearkernel == 1
				X{isubj}.K = X{isubj}.dat'*X{isubj}.dat;
			else
				kwidths = est_kwidth(X{isubj}.dat',5);
				X{isubj}.K = gausskern(X{isubj}.dat',X{isubj}.dat',kwidths(3)); 
			end
			X{isubj}.K = X{isubj}.K./max(eigs(X{isubj}.K));
		end
	end


	icondorder = 0;
	icolcond = 1;
	idepthcond = 1;
	movcond = 1;
	for isubj = 1:length(subjs)
	%isubj = 1;
		% find idcs of time slices of _all_ movies with the given colcond and depthcond
		idx = find(X{isubj}.conditions(:,1)>0 & ...
			X{isubj}.conditions(:,1)<=maxmovs & ...
			X{isubj}.conditions(:,2)==icolcond-1 & ...
			X{isubj}.conditions(:,3)==idepthcond-1);
	
		% extract order of stimuli
		% 120 for movielength: 40 slices a 3s each
		% 20 for empty slices between moves: 6-7 slices a 3s each
		condorder(idepthcond,icolcond,movcond,isubj)=...
			ceil(find(X{isubj}.conditions(:,1) == movcond & ...
			X{isubj}.conditions(:,2)==icolcond-1 & ...
			X{isubj}.conditions(:,3)==idepthcond-1,1,'first')*TR/(120+20));
		
		% sort movies
		[~,sortidx] = sort(X{isubj}.conditions(idx,1));
		idx = idx(sortidx);
		idx = reshape(idx,length(idx)/maxmovs,maxmovs)';
	
		% prepare test and training data sets
		testidx{isubj} = idx(movcond,:);
		training_movie_ids = setdiff(1:maxmovs,movcond);
		trainidx{isubj} = idx(training_movie_ids,:)';
		trainidx{isubj} = reshape(trainidx{isubj},1,prod(size(trainidx{isubj})));
	
		Xtrain{isubj} = X{isubj}.K(trainidx{isubj},trainidx{isubj});
		Xtest{isubj} = X{isubj}.K(testidx{isubj},trainidx{isubj});
	end
	
	% train model
	[c,directions,~] = cca(Xtrain,ncomp);

	% get brain networks and activation patterns
	for isubj = 1:length(subjs)
		brain_network{isubj} = directions{isubj}' * Xtrain{isubj};
	
	
		activation_pattern{isubj} = brain_network{isubj} * X{isubj}.dat(:,trainidx{isubj})';
		
	end
end

