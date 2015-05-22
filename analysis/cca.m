function [correlations,directions,components] = cca(X,ncomp,shrink)
% [correlations,directions,components] = cca(X,ncomp,kappa)
%
% 	multiway CCA
%
% INPUT
%	X       a cell array of dims-by-samples data matrices
%   ncomp   number of components
%	shrink	the regularizers
%

if nargin<3,
    shrink = 'auto';
end

for ivar=1:length(X)
    [dims(ivar),N{ivar}] = size(X{ivar});
    X{ivar} = zscore(X{ivar}')';
end
LH = zeros(sum(dims));
RH = zeros(sum(dims));

% cross-covariance matrix
V = cat(1,X{:});
LH = V*V'./N{1};

dims = [0 dims];
for ik=2:length(dims)
    % we need to remove the block diagonals on the cross-covariance terms
    inds = sum(dims(1:ik-1))+[1:dims(ik)];
    LH(inds,inds) = 0;
    % and add the auto-covariance on the ridge of the right-hand side
    % of the eigenvalue equation
    if strcmp(shrink,'auto')
        RH(inds,inds) = autoshrinkage(X{ik-1});
    else 
        C = X{ik-1} * X{ik-1}' ./ N{ik-1};
        RH(inds,inds) = (1-shrink)*C + shrink*trace(C)/dims(ik)*eye(dims(ik));
    end
end

% Compute the generalized eigenvectors
[Vs,c]=eig(LH,RH);

for ik=2:length(dims)
    inds = sum(dims(1:ik-1))+[1:dims(ik)];
    directions{ik-1} = fliplr(Vs(inds,end-ncomp+1:end));
    components{ik-1} = fliplr(X{ik-1}' * Vs(inds,end-ncomp+1:end));
end
%~ correlations = flipud(diag(c(end-ncomp:end,end-ncomp:end))/length(X));
correlations = flipud(diag(c(end-ncomp+1:end,end-ncomp+1:end))/length(X));


function Cstar = autoshrinkage(X)

%%% Empirical covariance
[p, n] = size(X);
Xn     = X - repmat(mean(X,2), [1 n]);
S      = Xn*Xn';
Xn2    = Xn.^2;
idxdiag    = 1:p+1:p*p;
%%% Define target matrix for shrinkage
nu = mean(S(idxdiag));
T  = nu*eye(p,p);

% calculate analytical shrinkage estimator
V     = 1/(n-1) * (Xn2 * Xn2' - S.^2/n);
gamma = n * sum(sum(V)) / sum(sum((S - T).^2));

%%% Estimate covariance matrix
Cstar = (gamma*T + (1-gamma)*S ) / (n-1);



