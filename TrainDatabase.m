function [X, C] = TrainDatabase(TrainDatabasePath, TrainImages, option)
% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     TrainDatabasePath      - Path of the training database
%               TrainImages            - Specific image of training for
%                                        each class.
%               option                 - [silence mirror]
%
% Returns:      X                      - A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MN and 'T' will be a MNxP 2D matrix.
%               C                      - ClassLabel of each training image.
%                                        size will be 1xP.
%
%  no_folder=size(dir([TrainDatabasePath,'\*']),1)-size(dir([TrainDatabasePath,'\*m']),1)-2;
    no_folder = 49;
    resize_dim = [80 60];
    if size(TrainImages,1) == 1;
        if size(TrainImages,2) == 1
            TrainImages = 1:TrainImages;
        end
        train = zeros(no_folder, length(TrainImages));
        for i = 1:no_folder
            train(i,:) = TrainImages;
        end
        TrainImages = train;
    end
%%%%%%%%%%%%%%%%%%%%%%%% Construction of 2D matrix from 1D image vectors
    image_dim = resize_dim(1) * resize_dim(2);
    X = zeros(image_dim, length(find(TrainImages)));
    C = zeros(1, size(X,2));

    if ~exist('TrainDatabasePath', 'var') || isempty(TrainDatabasePath)
        TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
    
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
    option = [silence mirror];
    if ~silence
        fprintf(1, 'Loading Faces:\n');
        if mirror
            fprintf(1, '\b (in Mirror Mode)\n');
        end
    end
    
    img_idx = 1;
    for i = 1:size(TrainImages, 1)
        samples = find(TrainImages(i,:));
        if ~silence
            fprintf(1, 'Class %d: %d samples\n', i, length(samples));
        end
        for s = 1:length(samples)
            img = sprintf('%s\\%d\\%d.bmp',TrainDatabasePath,i,TrainImages(i,s));
            X(:,img_idx) = LoadImage(img, [], option);
            C(img_idx) = i;
            img_idx = img_idx + 1;
        end
    end
    
    if ~exist('silence', 'var') || isempty(silence)
        fprintf(1, 'Database loaded: %d x %d\n', size(X, 1), size(X, 2));
    end
end
