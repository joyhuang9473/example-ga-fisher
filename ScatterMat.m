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
    fprintf(1, 'M,Sw,Sb: %2d/%2d (00:00:00/??:??:??)',0, c);
    timestart = clock();
    for i=1:c
        timeoff = clock() - timestart;
        timepass = (timeoff(4)*60 + timeoff(5))*60 + timeoff(6);
        [hour, minute, second] = calctime(timepass);
        fprintbackspace(20+5);
        fprintf(1, '%2d/%2d (%02d:%02d:%02d', i, c, hour, minute, second);
        [hour, minute, second] = calctime(timepass / i * (c - i + 1));
        fprintf(1, '/%02d:%02d:%02d)', hour, minute, second);
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
    timeoff = clock() - timestart;
    timepass = (timeoff(4)*60 + timeoff(5))*60 + timeoff(6);
    [hour, minute, second] = calctime(timepass);
    fprintbackspace(20);
    fprintf(1, ' (%02d:%02d:%02d)\n', hour, minute, second);
end
function fprintbackspace(b)
    for i = 1:b
        fprintf(1, '\b');
    end
end
function [hr, min, sec] = calctime(s)
	sec = mod(floor(s), 60);
	min = mod(floor(s / 60), 60);
	hr = mod(floor(s / 3600), 60);
end