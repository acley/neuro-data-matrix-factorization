function [H]=gausskern(Xtrain,Xtest,kwidth)
% Computes gaussian kernel between Xtrain and Xtest
size1=size(Xtrain);
size2=size(Xtest);
G = sum((Xtrain.*Xtrain),2);
H = sum((Xtest.*Xtest),2);
Q = repmat(G,1,size2(1));
R = repmat(H',size1(1),1);
H = Q + R - 2*Xtrain*Xtest';
H=exp(-H/(kwidth^2));
