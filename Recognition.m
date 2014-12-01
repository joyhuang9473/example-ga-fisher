function class = Recognition(Wopt, M, U, image, isUpj)
%% recognize an image

%% projection
    if exist('isUpj', 'var') && isUpj == 1
        Upj = U;
    else
        % Mpj = Wopt.' * M;
        Upj = zeros(size(Wopt, 2), size(U, 2));
        for i = 1:size(U, 2)
            Upj(:,i) = Wopt.' * U(:,i);
        end
    end
    
%% image pre-process
    image = double(image);
	image = imresize(image, [80 60]);
	image = rgb2gray(image);
    [d1, d2] = size(image);
    x = reshape(image', d1 * d2, 1);
    
    diff = x - M;
    proj = Wopt.' * diff;
    
%% calc dist
%     mdist = inf;
    K = size(Upj, 2);
    dist = zeros(1, K);
    for i = 1:K
        dist(i) = ( norm( proj - Upj(:,i) ) )^2;
    end
    [~, class] = min(dist);
    
%     class = 0;
%     mdist = inf;
%     for i = 1:size(U, 2)
%         d = 0;
%         for j = 1:length(proj)
%             d = d + (U(j,i) - proj(j)) ^ 2;
%         end
%         if d < mdist
%             class = i;
%             mdist = d;
%         end
%     end
end