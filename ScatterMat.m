function [me, u, Sw, Sb]=ScatterMat(X, C)
    [D, ~] = size(X);
    ClassLabel = unique(C); % Find all class labels
	c = length(ClassLabel); % c denotes number of classes
%% Find class means and scatter matrix
    me = mean(X, 2);
    u = [];
    Sw = zeros(D,D);
    Sb = zeros(D,D);
    for i=1:c
        Xi = X(:, C == ClassLabel(i));
        ni = size(Xi, 2);
        mi = mean(Xi, 2);
        u = [u mi];
        %% Find within-class scatter
        SXi = Xi - repmat(mi, 1, ni);
        Si{i} = SXi * SXi.'; %% [1] (110)
        Sw = Sw + Si{i}; %% [1] (109)
        %% Find between-class scatter
        SMi = mi - me;
        Sb = Sb + ni * SMi * SMi.'; %% [1] (114)
    end
end