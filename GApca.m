function [Wga, Lga, Wpca, Lpca] = GApca(X, U, M, Sw, ~, Wpca, Lpca, l, coeff)
%% function [Wga, Lga, Wpca, Lpca] = GApca(X, U, M, Sw, Sb, Wpca, Lpca, l, coeff)
% (X, U, M, Sw) or (X, U, M, [], [], Wpca, Lpca, l)
% X: training image = [x1 x2 x3 ... xn] (kxn, k is the dimension of each image)
% U: mean image of each class = [u1 u2 u3 ... uj] (kxj, k is dim of image, j is number of classes)
% M: mean image (kx1, k is ...)
% Sw: within-class scatter matrix
% Sb: between-class scatter matrix (unnecessary)
% l: rank(Sw)
% coeff: population & generation & GPUsupport of GA, = [popu gene gpu]
% Wga: princomp set after GA-PCA = [wi1 wi2 wi3 ... wil] (kxl, k is ...)
% Lga: eigenvalues (corresponding to Wga)
% Wpca: princomp set
% Lpca: eigenvalues (corresponding to Wpca)

%% init (pca, rank(Sw), coeff)
    fprintf(1, 'Wpca: processing...');
    if ~exist('Wpca', 'var') || isempty(Wpca)
        [Wpca, ~, Lpca] = cvPca(X);
    end
    [Dpc, Npc] = size(Wpca);
    fprintbackspace(13);
    fprintf(1, '%d x %d\n', Dpc, Npc);
    fprintf(1, 'Rank(Sw): processing...');
    if ~exist('l', 'var') || isempty(l)
        rankSwTStart = tic();
        try % using GPU if possible
            l = gather(rank(gpuArray(Sw)));
        catch
            l = rank(Sw);
        end
        rankSwTCost = calctime(toc(rankSwTStart));
    end
    l = max(min(l, Npc), ceil(Npc*0.2));
    k = ceil((Npc - l) / Npc); % k == 0 if Npc == l
    fprintbackspace(13);
    fprintf(1, '%d\n', l);
    if exist('rankSwTCost', 'var')
        fprintf(1, '\b (%s)\n', rankSwTCost);
    end
    fprintf(1, 'GA-PCA: init...');
    if ~exist('coeff', 'var') || isempty(coeff)
        coeff = [80 80];
    end
    population = coeff(1);
    generation = coeff(2);
    GPUsupport = true;
    if length(coeff) > 2
        GPUsupport = logical(coeff(3));
    end
    GPUsupport = init(Wpca, Lpca, X, U, M, GPUsupport);
    
%% init (population, fitness)
    P = zeros(Npc, population);
    F = zeros(1, population);
    P(1:l,:) = 1;
    fprintbackspace(7);
    fprintf(1, 'fitness init... (%3d/%3d)', 1, population);
    F(1) = fitness(P(:,1));
    win = P(:,1); fit = F(1);
    for i = 2:(population*k)
        fprintbackspace(9);
        fprintf(1, '(%3d/%3d)', i, population);
        P(:,i) = P(randperm(Npc),i);
        F(:,i) = fitness(P(:,i));
        if F(i) > fit
            win = P(:,i); fit = F(i);
        end
    end
    fprintbackspace(25);
    
%% main GA
    fprintf(1, '%3d/%3d (00:00:00/??:??:??)', 0, generation);
    timestart = tic();
    for n = 1:generation
        fprintf(1, '\n>> ');
        %% selection
        fprintf(1, 'selection...');
        c = ceil((0.80 - 0.1 * (n / generation)) * population / 2) * 2;
        try
            c_best = floor(c * 0.75);
            [~, I] = sort(F, 'descend');
            % shuffle I from (c_best+1) to (population)
            I(c_best+1:population) = I(randperm(population-c_best)+c_best);
            pool = [I(1:c_best) I(c_best+1:c)]; % pool holds the index of P(:,i)
            pool = pool(randperm(c));
        catch
        end
        %% crossover
        fprintf(1, 'crossover...');
        for i = 1:(c/2*k)
        try
            p1 = pool(i + i - 1);
            p2 = pool(i + i);
            r = [randi(Npc) randi(Npc)];
            r = min(r):max(r);
            sz = find(P(r, p1) ~= P(r, p2)) + (r(1) - 1);
            szr = sz(randperm(length(sz)));
            P(sz, [p1 p2]) = P(szr, [p1 p2]);
        catch
        end
        end
        %% mutation
        fprintf(1, 'mutation...');
        m = ceil((0.23 - 0.2 * (n / generation)) * population * Npc);
        for i = 1:(m*k)
        try
            select = randi(population);
            mp1 = randi(Npc);
            mp2 = randi(Npc);
            while P(mp2,select) == P(mp1,select)
                mp2 = randi(Npc);
            end
            P([mp1 mp2],select) = P([mp2 mp1],select);
        catch
        end
        end
        %% calculate fitness
        fprintf(1, 'fitness...');
        for i = 1:(population*k)
            fprintf(1, ' (%3d/%3d)', i, population);
            F(:,i) = fitness(P(:,i));
            if F(i) > fit
                win = P(:,i); fit = F(i);
            end
            fprintbackspace(10);
        end
        fprintbackspace(12+12+11+10+4);
        %% print estimate time detail
        fprintbackspace(7+20);
        [current, timepass] = calctime(toc(timestart));
        [estimate] = calctime(timepass / n * (generation - n));
        fprintf(1, '%3d/%3d (%s/%s)', n, generation, current, estimate);
    end
	fprintbackspace(20+7);
    fprintf(1, '[%d %d]', population, generation);
    fprintf(1, ' (%s)\n', calctime(toc(timestart)));
    
%% result
    if GPUsupport
        fprintf(1, '\b GPU+\n');
    end
    fprintf(1, 'Fitness: %.2f\n', fit);
    Wga = Wpca(:, win == 1);
    Lga = Lpca(win == 1);
    fprintf(1, 'Wga: %d x %d\n', size(Wga,1), size(Wga,2));
    init([]);
end

function GPUAcc = init(Wpca, Lpca, Xv, Uv, Mv, GPUAcc)
    global W L X U M N K sumL GPUsupport;
    if exist('Wpca', 'var') && ~isempty(Wpca)
        try
            if logical(GPUAcc)
                W = gpuArray(Wpca);
                L = gpuArray(Lpca);
                X = gpuArray(Xv);
                U = gpuArray(Uv);
                M = gpuArray(Mv);
                GPUAcc = true;
            else
                GPUAcc = false;
            end
        catch
            GPUAcc = false;
        end
        if GPUAcc == false
            W = Wpca; L = Lpca; X = Xv; U = Uv; M = Mv;
        end
        N = size(X, 2);
        K = size(U, 2);
        sumL = sum(L);
        GPUsupport = GPUAcc;
    else
        clear global W L X U M N K sumL GPUsupport;
    end
end

function F = fitness(enc)
    global W L X U M N K sumL GPUsupport;
    %% P = (wi1, wi2, wi3, ..., wil)
    chromo = (enc == 1);
    P = W(:,chromo);
    P = P.';
    %% Fg
    m = P * M;
    t = (P * X(:,1)) - m;
    sigma = (t * t.');
    for i = 2:N
        t = (P * X(:,i)) - m;
        sigma = sigma + (t * t.');
    end
    sigma = pinv(sigma / N);
    d = inf;
    for i = 1:K
        t = (P * U(:,i)) - m;
        d = min(d, (t.' * sigma * t));
    end
    Fg = sqrt(d);
    %% Fa
    Fa = 1;
    %% Fc
    SE = sum(L(chromo)) / sumL;
    Fc = exp(20 * (SE - 0.99));
    %% Fitness result
    F = Fg * Fa * Fc;
    if GPUsupport
        F = gather(F);
    end
end