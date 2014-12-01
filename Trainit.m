function [Wopt, M, U] = Trainit(train_nface)
    % A sample script, which shows the usage of functions, included in
    % PCA-based face recognition system (GA-Fisher method)

    % You can customize and fix initial directory paths
    TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    [X, C] = TrainDatabase(TrainDatabasePath, train_nface);
    % [m, A, Eigenfaces] = EigenfaceCore(T);
    [Wopt, M, U] = GAFisherCore(X, C);
end
