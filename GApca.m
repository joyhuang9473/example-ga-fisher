function [Wga, Lga] = GApca(W_, L_, X_, U_, M_, l)
%% init
    global W L X U M;
    W = W_;
    L = L_;
    X = X_;
    U = U_;
    M = M_;
    [Dpc, Npc] = size(W);
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
    for n = 1:generation
        %% selection
        c = ceil(crossover(n, generation) * population / 2) * 2;
        c_best = floor(c * 0.5);
        [~, I] = sort(F, 'descend');
        I(c_best+1:population) = I(randperm(population-c_best)+c_best);
        pool = [I(1:c_best) I(c_best+1:c)]; % pool holds the index of P(:,i)
        pool = pool(randperm(c));
        %% crossover
        for i = 1:(c/2)
            p1 = pool(i + i - 1);
            p2 = pool(i + i);
            range = [randi(Npc) randi(Npc)];
            range = min(range):max(range);
            xchg = [P(range, p1) P(range, p2)];
            s1 = intersect(find(xchg(:,1)==1),find(xchg(:,2)==1));
            s0 = intersect(find(xchg(:,1)==0),find(xchg(:,2)==0));
            sz = 1:Npc;
            sz(union(s1, s0)) = [];
            xchg(sz,:) = xchg(sz(randperm(length(sz))),:);
            P(range, p1) = xchg(:,1);
            P(range, p2) = xchg(:,2);
        end
        %% mutation
        m = ceil(mutation(n, generation) * population * Npc);
        for i = 1:m
            select = randi(population);
            m0 = find(P(:,select) == 0);
            m1 = find(P(:,select) == 1);
            P(m0(randi(Npc - l)),select) = 1;
            P(m1(randi(l)),select) = 0;
        end
        %% calculate fitness
        for i = 1:population
            F(i) = fitness(P(:,i));
            if F(i) > F(win)
                win = i;
            end
        end
    end
%% result
    Wga = W(:, P(:,win) == 1);
    Lga = L(P(:,win) == 1);
    clear W L X U M;
end

function c = crossover(n, G)
    c = 0.80 - 0.1 * (n / G);
end
function m = mutation(n, G)
    m = 0.23 - 0.2 * (n / G);
end
function F = fitness(enc)
    global W L X U M;
    [dim, N] = size(X);
    K = length(U);
    %% generate P = (wi1, wi2, wi3, ..., wil)
    P = W(:,enc == 1);
    P = P';
    %% Fg
    m = P * M;
    sigma = zeros(dim);
    for i = 1:N
        t = (P * X(:,i)) - m;
        sigma = sigma + (t * t');
    end
    sigma = sigma / N; % inv(sigma / N)
    d = inf;
    for i = 1:K
        t = (P * U(:,i)) - m;
        d = min(d, sqrt(t' / sigma * t)); % Replace b*inv(A) with b/A
    end
    Fg = d;
    %% Fa
    Fa = 1;
    %% Fc
    SE = sum(L(enc == 1)) / sum(L);
    Fc = e ^ (20 * (SE - 0.99));
    %% Fitness result
    F = Fg * Fa * Fc;
end