function [class, bboxes] = Recognition(Wopt, Xt, Ct, frame, bboxes)
%% recognize faces in given image
    if ~exist('BB', 'var') || isempty(bboxes)
        FDetect = vision.CascadeObjectDetector;
        bboxes = step(FDetect,frame);
    end
    resize_dim = [80 60];
    resize = resize_dim(1) * resize_dim(2);
    frame = rgb2gray(frame);

    Xq = zeros(resize, size(bboxes, 1));
    for i = 1:size(Xq, 2)
        face = imcrop(frame, bboxes(i,:));
        face = imresize(face, resize_dim);
        Xq(:,i) = reshape(face', resize, 1);
    end

    Yt = cvLdaProj(Xt, Wopt);
    Yq = cvLdaProj(Xq, Wopt);
    [class, ~] = cvKnn(Yq, Yt, Ct, 1);
end