function kwidths = est_kwidth(X,howmany)

size1=size(X);

G = sum((X.*X),2);
Q = repmat(G,1,size1(1));
R = repmat(G',size1(1),1);
H = Q + R - 2*X*X';
kwidths = quantile(H(:),linspace(0.1,.9,howmany));