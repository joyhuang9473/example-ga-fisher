function [Wopt] = Whiten(Sw, Sb, Wga, Lga, Wconj, S)
%% Process a whitening procedure

    %% turn Lga to diag matrix
    col_Lga = Lga';
    diag_Lga = diag(col_Lga.^(-1/2));
    Wga_whiten = Wga * diag_Lga;

    clear col_Lga diag_Lga;
    %% Computing Wlda
    if ~exist('Wconj', 'var') || isempty(Wconj)
        [Wconj, S] = eig(Sb,Sw);
    end
    % save eig;
    [S, inx] = sort(diag(S),1,'descend');
    [M, N] = size(Wga);
    M = min(M, length(inx));
    Wconj = Wconj(:,inx(1:M));
    % Wlda = Wga_whiten^(-1) * Wconj;
    Wlda = pinv(Wga_whiten) * Wconj;

    %% Get optimal projection for GA-Fisher
    Wopt_transpose = Wlda' * Wga_whiten';
    Wopt = Wopt_transpose';
end
