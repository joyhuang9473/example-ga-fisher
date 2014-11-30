function [Wga, Lga] = GApca(W_, L_, X_, U_, M_, l)
%% function [Wga, Lga] = GApca(W, L, X, U, M, l)
%% init
    global W L X U M;
    W = W_;
    L = L_;
    X = X_;
    U = U_;
    M = M_;
    [~, Npc] = size(W);
    population = 200;
    generation = 400;
    P = zeros(Npc, population);
    F = zeros(1, population);
    for i = 1:population
        chromo = zeros(Npc, 1);
        chromo(1:l) = 1;
        P(:,i) = chromo;
    end
    F(1) = fitness(P(:,1));
    win = 1;
    for i = 2:population
        P(:,i) = P(randperm(Npc),i);
        F(i) = fitness(P(:,i));
        if F(i) > F(win)
            win = i;
        end
    end
%% main GA
    fprintf(1, 'GA-PCA:   0/%3d (00:00:00/??:??:??)', generation);
    timestart = clock();
    for n = 1:generation
        %% print looping detail
        timeoff = clock() - timestart;
        timepass = (timeoff(4)*60 + timeoff(5))*60 + timeoff(6);
        [hour, minute, second] = calctime(timepass);
        fprintf(1, '\b\b\b\b\b\b\b');
        fprintf(1, '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
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
            range = min(range):max(range);
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
    fprintf(1, '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    fprintf(1, ' (%02d:%02d:%02d)\n', hour, minute, second);
%% result
    Wga = W(:, P(:,win) == 1);
    Lga = L(P(:,win) == 1);
    clear W L X U M;
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
    P = P';
    %% Fg
    m = P * M;
    sigma = zeros(size(P,1));
    for i = 1:N
        t = (P * X(:,i)) - m;
        sigma = sigma + (t * t');
    end
    sigma = sigma / N;
    if det(sigma) ~= 0
        sigma = inv(sigma);
    else
        sigma = pinv(sigma);
    end
    d = inf;
    for i = 1:K
        t = (P * U(:,i)) - m;
        d = min(d, (t' * sigma * t));
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