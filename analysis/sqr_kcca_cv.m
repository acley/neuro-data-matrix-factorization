function [cisc_cv,cisc_ids,condorder] = sqr_kcca_cv(subject_data)
%~ sqr_set_paths

%~ matsavepath = '/Users/felix/Data/SQR/matexport_lowres'
matsavepath = '/home/achim/Data/dummy_sequrea/preprocessed_data';

ncomp = 20;
maxmovs = 3;
TR = 3;

subjs = dir(fullfile(matsavepath,'SQR_*'));

linearkernel = 0;

%~ for isubj = 1:length(subjs)
    %~ fprintf('Reading Subject %d\n',isubj)
    %~ X{isubj} = load(fullfile(matsavepath,subjs(isubj).name));
    %~ X{isubj}.dat = zscore(X{isubj}.dat')';
    %~ if linearkernel == 1
        %~ X{isubj}.K = X{isubj}.dat'*X{isubj}.dat;
    %~ else
        %~ kwidths = est_kwidth(X{isubj}.dat',5);
        %~ X{isubj}.K = gausskern(X{isubj}.dat',X{isubj}.dat',kwidths(3)); 
    %~ end
    %~ X{isubj}.K = X{isubj}.K./max(eigs(X{isubj}.K));
%~ end

X = subject_data;

% loop through all experimental conditions
for icolcond = 1:2
    for idepthcond =1:2
        for movcond = 1:maxmovs
            for isubj = 1:length(subjs)
                idx = find(   X{isubj}.conditions(:,1)>0 & ...
                    X{isubj}.conditions(:,1)<=maxmovs & ...
                    X{isubj}.conditions(:,2)==icolcond-1 & ...
                    X{isubj}.conditions(:,3)==idepthcond-1);
                % extract order of stimuli
                condorder(idepthcond,icolcond,movcond,isubj)=...
                    ceil(find(X{isubj}.conditions(:,1) == movcond & ...
                        X{isubj}.conditions(:,2)==icolcond-1 & ...
                        X{isubj}.conditions(:,3)==idepthcond-1,1,'first')*TR/(120+20));
                if ~isempty(idx)
                    % sort movies
                    [~,sortidx] = sort(X{isubj}.conditions(idx,1));
                    idx = idx(sortidx);
                    idx = reshape(idx,length(idx)/maxmovs,maxmovs)';
                    
                    % train on one movie
                    testidx = idx(movcond,:);
                    %~ trainidx = vec(idx(setdiff(1:maxmovs,movcond),:)');
                    trainidx = reshape(idx(setdiff(1:maxmovs,movcond),:),1,[]);
                    Xtrain{isubj} = X{isubj}.K(trainidx,trainidx);
                    Xtest{isubj} = X{isubj}.K(testidx,trainidx);
                end
            end
            if ~isempty(idx)
                [c,directions,~] = cca(Xtrain,ncomp);
                %~ score(icolcond,idepthcond,movcond,:) = c;
                c
                
                % compute canonical components on hold-out data (i.e. imovie)
                for isubj=1:length(Xtrain)
                    canonical_components_cv{isubj} = (directions{isubj}'*Xtest{isubj}')';
                end
                
                % compute CISC on hold out data
                [cisc_cv(icolcond,idepthcond,movcond,:,:),cisc_ids(icolcond,idepthcond,movcond,:,:)] ...
                    = sequ_cisc(canonical_components_cv,1:10);
            end
        end
        
    end
end

