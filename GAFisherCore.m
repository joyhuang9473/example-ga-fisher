function [Wopt, X, C] = GAFisherCore(X, C, GAcoef)
%% function [Wopt, X, C] = GAFisherCore(X, C)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% C: class label = [c1 c2 c3 ... cn] (corresponding to X) (1xn or nx1)
% Wopt: optimal projection after GA-Fisher (kxp, k is the dim of each comp)
% GAcoef: population & generation of GA = [popu gene GPU]
    
    fprintf(1, 'GA-Fisher Core\n');
    fprintf(1, 'Info: %d x %d, [%d %d]\n', size(X,1), size(X,2), GAcoef(1), GAcoef(2));
    timestart = tic();
    [M, U, Sw, Sb] = ScatterMat(X, C);
    [Wga, Lga] = GApca(X, U, M, Sw, Sb, [], [], [], GAcoef);
    [Wopt] = Whiten(Sw, Sb, Wga, Lga);
    fprintf(1, 'Done! (%s)\n', calctime(toc(timestart)));
end