function [me, u, Sw, Sb]=ScatterMat(X, C)
%% function [me, u, Sw, Sb] = ScatterMat(X, C)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% C: class label = [c1 c2 c3 ... cn] (corresponding to X) (1xn or nx1)
%
% me: mean image of X (kx1)
% u: mean image of each class (kxj, j classes)
% Sw: within-class scatter matrix (kxk)
% sb: between-class scatter matrix (kxk)

    [D, ~] = size(X);
    ClassLabel = unique(C); % Find all class labels
	c = length(ClassLabel); % c denotes number of classes
%% Find class means and scatter matrix
    me = mean(X, 2);
    u = zeros(D, c);
    Sw = zeros(D,D);
    Sb = zeros(D,D);
    fprintf(1, 'Sw,Sb: %2d/%2d (00:00:00/??:??:??)',0, c);
    timestart = clock();
    for i=1:c
        [current, timepass] = calctime(clock(), timestart);
        [estimate] = calctime(timepass / i * (c - i + 1));
        fprintbackspace(20+5);
        fprintf(1, '%2d/%2d (%s/%s)', i, c, current, estimate);
        Xi = X(:, C == ClassLabel(i));
        ni = size(Xi, 2);
        mi = mean(Xi, 2);
        u(:,i) = mi;
        %% Find within-class scatter
        SXi = Xi - repmat(mi, 1, ni);
        Si = SXi * SXi.'; %% [1] (110)
        Sw = Sw + Si; %% [1] (109)
        %% Find between-class scatter
        SMi = mi - me;
        Sb = Sb + ni * SMi * SMi.'; %% [1] (114)
    end
    fprintbackspace(20+5);
    fprintf(1, '%d x %d (%s)\n', D, D, calctime(clock(), timestart));
end
