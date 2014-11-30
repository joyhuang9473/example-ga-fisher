function GApcaDemo
    X = rand(14, 20); % 20 samples (dim is 14)
    C = randi(8, 1, 20); % class label of each sample
    C
    X
    [M, U, Sw, ~] = ScatterMat(X, C);
    [W, ~, L] = pca(X');
    [Wga, Lga] = GApca(W, L, X, U, M, rank(Sw));
    W
    L
    Wga
    Lga
end