function [image, raw] = LoadImage(path, resize_dim, option, FDetect)
%% loading an image from specific path
% resize_dim: default is 80 x 60
% option: [silence mirror], default are [false false]
%
% image: resized image (gray)
% raw: original image

    if exist('option', 'var') && ~isempty(option)
        silence = logical(option(1));
        if length(option) > 1
            mirror = logical(option(2));
        else
            mirror = false;
        end
    else
        silence = false;
        mirror = false;
    end
    if ~silence
        fprintf(1, '-loading %s...\n', path);
    end
    image = imread(path);

    if ~exist('FDetect', 'var') || isempty(FDetect)
        FDetect = vision.CascadeObjectDetector;
    end
    %Returns Bounding Box values based on number of objects
    BB = step(FDetect,image);
    % step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].

    % Somtimes the program will catch more than 1 face in a picture, such as irow==2, so we choose the second face only.
    [irow, ~] = size(BB);
    if irow == 1
        image = imcrop(image,BB);
    elseif irow > 1
        N = ndims(BB);
        if ~silence
      		fprintf(1, '--strange face number: %d\n', N);
        end
        % image = imcrop(image, BB(2,:));
        [~, m] = max(BB(:,3) + BB(:,4));
        image = imcrop(image, BB(m,:));
    else
        if ~silence
      		fprintf(1, '--NO face can be detected!!\n');
        end
        [height, width] = size(image);
        BB = [width*0.09 height*0.1 width*0.175 height*0.8];
        image = imcrop(image, BB);
    end
    
    if mirror
        image = flip(image, 2);
    end
    raw = image;

    if ~exist('resize_dim', 'var') || isempty(resize_dim)
        resize_dim = [80 60];
    end
    
    image = imresize(image, resize_dim);          
    image = rgb2gray(image);
    [irow, icol] = size(image);

    image = reshape(image',irow*icol,1);  
end