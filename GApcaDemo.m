function GApcaDemo
    X = rand(14, 20); % 20 samples (dim is 14)
    C = randi(4, 1, 20); % class label of each sample
    [M, U, Sw, ~] = ScatterMat(X, C);
    [Wga, Lga, W, L] = GApca(X, U, M, Sw, [], [], [], [], [200 100]);
    print('C', C);
    print('X', X);
    print('W', W);
    print('L', L);
    print('Wga', Wga);
    print('Lga', Lga);
end
function print(label, arg)
    fprintf(1, '%s: %d x %d\n', label, size(arg, 1), size(arg, 2));
end