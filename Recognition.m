function [class, BB] = Recognition(Wopt, Xt, Ct, image, FDetect)
%% recognize an image
    if ~exist('FDetect', 'var') || isempty(FDetect)
        FDetect = vision.CascadeObjectDetector;
    end
    BB = step(FDetect,image);
    class = zeros(size(BB, 1), 1);
    resize_dim = [80 60];
    
    Yt = cvLdaProj(Xt, Wopt);
    Xq = zeros(size(Xt, 1), 1);
    
    for i = 1:size(BB, 1);
        % image preprocess
        face = imcrop(image, BB(i,:));
        face = imresize(face, resize_dim);          
        face = rgb2gray(face);
        [irow, icol] = size(face);
        Xq(:,1) = reshape(face',irow*icol,1);
        
        % recognize
        Yq = cvLdaProj(Xq, Wopt);
        [class(i), ~] = cvKnn(Yq, Yt, Ct, 1);
    end
    
end