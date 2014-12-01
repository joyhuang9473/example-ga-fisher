function [Wopt, M, U]=Trainit(train_nface)
    % A sample script, which shows the usage of functions, included in
    % PCA-based face recognition system (GA-Fisher method)


    % clear all
    % clc
    % close all

    % You can customize and fix initial directory paths
    TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    [X, C] = TrainDatabase(TrainDatabasePath, train_nface);
    % [m, A, Eigenfaces] = EigenfaceCore(T);
    [Wopt, M, U] = GAFisherCore(X, C);
    M = Wopt.' * M;
    for i = 1:size(U, 2)
        U(:,i) = Wopt.' * U(:,i);
    end
end
