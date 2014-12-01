function [Wopt] = Whiten(Sw, Sb, Wga, Lga)
%% Process a whitening procedure

%% turn Lga to diag matrix
col_Lga = Lga';
diag_Lga = diag(col_Lga);
Wga_whiten = Wga * diag_Lga.^(-1/2);

clear col_Lga diag_Lga;
%% Computing Wlda
[Wconj, S] = eig(Sb,Sw);
[S,inx] = sort(diag(S),1,'descend');
M = min(M, length(inx));
Wconj = Wconj(:,inx(1:M));
Wlda = Wga_whiten^(-1) * Wconj;

%% Get optimal projection for GA-Fisher
Wopt_transpose = Wlda' * Wga_whiten';
Wopt = Wopt_transpose';
