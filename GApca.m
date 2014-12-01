function [Wpca, Lpca, Wga, Lga] = GApca(Xv, Uv, Mv, Sw, ~, Wpca, Lpca, l, coeff)
%% function [Wpca, Lpca, Wga, Lga] = GApca(X, U, M, Sw, Sb, Wpca, Lpca, l, coeff)
% (X, U, M, Sw) or (X, U, M, [], [], Wpca, Lpca, l)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% U: mean image of each class = [u1 u2 u3 ... uj] (kxj, k is dim of image, j is number of classes)
% M: mean image (kx1, k is ...)
% Sw: within-class scatter matrix
% Sb: between-class scatter matrix (unnecessary)
% l: rank(Sw)
% coeff: population & generation of GA, = [popu gene]
% Wpca: princomp set
% Lpca: eigenvalues (corresponding to Wpca)
% Wga: princomp set after GA-PCA = [wi1 wi2 wi3 ... wil] (kxl, k is ...)
% Lga: eigenvalues (corresponding to Wga)

%% init (pca, rank(Sw))
    global W L X U M;
    fprintf(1, 'Wpca, Lpca: processing...');
    if ~exist('Wpca', 'var') || isempty(Wpca)
        [Wpca, ~, Lpca] = pca(Xv');
    end
    fprintbackspace(13);
    fprintf(1, '%d x %d\n', size(Wpca, 1), size(Wpca, 2));
    fprintf(1, 'Rank(Sw): processing...');
    if ~exist('l', 'var') || isempty(l)
        l = rank(Sw);
    end
    fprintbackspace(13);
    fprintf(1, '%d\n', l);
    fprintf(1, 'GA-PCA: population init...');
    W = Wpca; L = Lpca; X = Xv; U = Uv; M = Mv;
    clear X_ U_ M_;
    [~, Npc] = size(W);
    if ~exist('coeff', 'var') || isempty(Wpca)
        coeff = [200 400];
    end
    population = coeff(1);
    generation = coeff(2);
    P = zeros(Npc, population);
    F = zeros(1, population);
    for i = 1:population
        chromo = zeros(Npc, 1);
        chromo(1:l) = 1;
        P(:,i) = chromo;
    end
    fprintbackspace(18);
    fprintf(1, 'fitness init... (%3d/%3d)', 1, population);
    F(1) = fitness(P(:,1));
    win = 1;
    for i = 2:population
        fprintbackspace(9);
        fprintf(1, '(%3d/%3d)', i, population);
        P(:,i) = P(randperm(Npc),i);
        F(i) = fitness(P(:,i));
        if F(i) > F(win)
            win = i;
        end
    end
    fprintbackspace(25);
%% main GA
    fprintf(1, '%3d/%3d (00:00:00/??:??:??)', 0, generation);
    timestart = clock();
    for n = 1:generation
        %% print looping detail
        timeoff = clock() - timestart;
        timepass = (timeoff(4)*60 + timeoff(5))*60 + timeoff(6);
        [hour, minute, second] = calctime(timepass);
        fprintbackspace(7+20);
        fprintf(1, '%3d/%3d (%02d:%02d:%02d', n, generation, hour, minute, second);
        [hour, minute, second] = calctime(timepass / n * (generation - n + 1));
        fprintf(1, '/%02d:%02d:%02d)', hour, minute, second);
        if Npc == l
            continue;
        end
        modified = zeros(1, population);
        %% selection
        c = ceil(crossover(n, generation) * population / 2) * 2;
        c_best = floor(c * 0.5);
        [~, I] = sort(F, 'descend');
        I(c_best+1:population) = I(randperm(population-c_best)+c_best);
        pool = [I(1:c_best) I(c_best+1:c)]; % pool holds the index of P(:,i)
        pool = pool(randperm(c));
        modified(pool) = 1;
        %% crossover
        for i = 1:(c/2)
            p1 = pool(i + i - 1);
            p2 = pool(i + i);
            range = [randi(Npc) randi(Npc)];
            range = [1:min(range) max(range):Npc];
            xchg = [P(:, p1) P(:, p2)];
            s1 = intersect(find(xchg(:,1)==1),find(xchg(:,2)==1));
            s0 = intersect(find(xchg(:,1)==0),find(xchg(:,2)==0));
            sz = 1:Npc;
            sz(union(union(s1, s0),range)) = [];
            xchg(sz,:) = xchg(sz(randperm(length(sz))),:);
            P(:, p1) = xchg(:,1);
            P(:, p2) = xchg(:,2);
        end
        %% mutation
        m = ceil(mutation(n, generation) * population * Npc);
        for i = 1:m
            select = randi(population);
            modified(select) = 1;
            m0 = find(P(:,select) == 0);
            m1 = find(P(:,select) == 1);
            P(m0(randi(Npc - l)),select) = 1;
            P(m1(randi(l)),select) = 0;
        end
        %% calculate fitness
        for i = find(modified)
            F(i) = fitness(P(:,i));
            if F(i) > F(win)
                win = i;
            end
        end
    end
    timeoff = clock() - timestart;
    timepass = (timeoff(4)*60 + timeoff(5))*60 + timeoff(6);
    [hour, minute, second] = calctime(timepass);
	fprintbackspace(20);
    fprintf(1, ' (%02d:%02d:%02d)\n', hour, minute, second);
%% result
    Wga = W(:, P(:,win) == 1);
    Lga = L(P(:,win) == 1);
    clear W L X U M;
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
function c = crossover(n, G)
    c = 0.80 - 0.1 * (n / G);
end
function m = mutation(n, G)
    m = 0.23 - 0.2 * (n / G);
end
function F = fitness(enc)
    global W L X U M;
    [~, N] = size(X);
    K = size(U, 2);
    %% generate P = (wi1, wi2, wi3, ..., wil)
    P = W(:,enc == 1);
    P = P.';
    %% Fg
    m = P * M;
    sigma = zeros(size(P,1));
    for i = 1:N
        t = (P * X(:,i)) - m;
        sigma = sigma + (t * t');
    end
    sigma = sigma / N;
    try
        sigma = (sigma / N) ^ (-1);
    catch
        sigma = pinv(sigma);
    end
    d = inf;
    for i = 1:K
        t = (P * U(:,i)) - m;
        d = min(d, (t.' * sigma * t));
    end
    Fg = sqrt(d);
    %% Fa
    Fa = 1;
    %% Fc
    SE = sum(L(enc == 1)) / sum(L);
    Fc = exp(20 * (SE - 0.99));
    %% Fitness result
    F = Fg * Fa * Fc;
end