function [W] = FisherfaceCore(X, C)
%% function [Wopt, M, U] = FisherfaceCore(X, C)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% C: class label = [c1 c2 c3 ... cn] (corresponding to X) (1xn or nx1)
%
% Wopt: optimal projection after GA-Fisher (kxp, k is the dim of each comp)
% M: mean image of X (kx1)
% U: mean image of each class = [u1 u2 u3 ... uj] (kxj, j is the number of classes)
    
    fprintf(1, 'Fisherface Core\n');
    [D, Nt] = size(X);
    [W] = cvLda(X, C, min(D, Nt-1));
    fprintf(1, 'Fisherface Done\n');
end