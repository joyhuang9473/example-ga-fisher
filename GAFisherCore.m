function [Wopt, M, U] = GAFisherCore(X, C)
%% function [Wopt, M, U] = GAFisherCore(X, C)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% C: class label = [c1 c2 c3 ... cn] (corresponding to X) (1xn or nx1)
%
% Wopt: optimal projection after GA-Fisher (kxp, k is the dim of each comp)
% M: mean image of X (kx1)
% U: mean image of each class = [u1 u2 u3 ... uj] (kxj, k is the dim of image, j is the number of classes)
    
    fprintf(1, 'GA-Fisher Core\n');
    [M, U, Sw, Sb] = ScatterMat(X, C);
    [W, ~, Wga, Lga] = GApca(X, U, M, Sw, Sb);
    Wopt = Whiten(W, Sw, Sb, Wga, Lga);
end