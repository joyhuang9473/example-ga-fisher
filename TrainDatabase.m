function [X, C] = TrainDatabase(TrainDatabasePath, TrainImages)
% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     TrainDatabasePath      - Path of the training database
%
% Returns:      X                      - A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MN and 'T' will be a MNxP 2D matrix.
%               C                      - ClassLabel of each training image.
%                                        size will be 1xP.
%
%%%%%%%%%%%%%%%%%%%%%%%% File management

%  no_folder=size(dir([TrainDatabasePath,'\*']),1)-size(dir([TrainDatabasePath,'\*m']),1)-2;
    no_folder = 49;
    resize_dim = [80 60];
    [td1, td2] = size(TrainImages);
    if td1 == 1 || td2 == 1;
        if td1 == 1 && td2 == 1
            TrainImages = 1:TrainImages;
        elseif td2 == 1
            TrainImages = TrainImages';
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
    
    disp('Loading Faces:');
    img_idx = 1;
    for i = 1:size(TrainImages, 1)
        samples = find(TrainImages(i,:));
        fprintf(1, 'Class %d: %d samples\n', i, length(samples));
        for s = 1:length(samples)
            img = sprintf('%s\\%d\\%d.bmp',TrainDatabasePath,i,TrainImages(i,s));
            X(:,img_idx) = LoadImage(img);
            C(img_idx) = i;
            img_idx = img_idx + 1;
        end
    end
    fprintf(1, 'Database loaded: %d x %d\n', size(X, 1), size(X, 2));
end
