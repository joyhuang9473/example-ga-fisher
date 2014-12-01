function [Wopt, X, C] = Trainit(train_nface)
    % A sample script, which shows the usage of functions, included in
    % PCA-based face recognition system (GA-Fisher method)

    [X, C] = TrainDatabase([], train_nface);
    % [m, A, Eigenfaces] = EigenfaceCore(T);
    [Wopt] = FisherfaceCore(X, C);
end
