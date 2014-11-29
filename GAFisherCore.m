function [Wopt, M, U] = GAFisherCore(X, C)
    [M, U, Sw, Sb] = ScatterMat(X, C);
    [W, ~, L] = pca(X);
    [Wga, Lga] = GApca(W, L, X, U, M, rank(Sw));
    Wopt = Whiten(W, Sw, Sb, Wga, Lga);
end