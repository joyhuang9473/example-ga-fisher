function [T, C] = TrainDatabase(TrainDatabasePath, train_nface)
% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     TrainDatabasePath      - Path of the training database
%
% Returns:      T                      - A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MN and 'T' will be a MNxP 2D matrix.
%               C                      - ClassLabel of each training image.
%                                        size will be 1xP.
%
%%%%%%%%%%%%%%%%%%%%%%%% File management

%  no_folder=size(dir([TrainDatabasePath,'\*']),1)-size(dir([TrainDatabasePath,'\*m']),1)-2;
    no_folder = 49;
    nface = train_nface;    % Choose how many pictures of one person to train.
    resize_dim = [80 60];
%%%%%%%%%%%%%%%%%%%%%%%% Construction of 2D matrix from 1D image vectors
    image_dim = resize_dim(1) * resize_dim(2);
    image_num_total = no_folder * nface;
    T = zeros(image_dim, image_num_total);
    C = zeros(1, image_num_total);

    if ~exist('TrainDatabasePath', 'var') || isempty(TrainDatabasePath)
        TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
    
    disp('Loading Faces:');
    img_idx = 1;
    for i = 1 : no_folder
        % stk = int2str(i);
        % disp(stk);
        fprintf(1, 'Class %d: %d samples\n', i, nface);
        % stk = strcat('\',stk,'\*bmp');
        % folder_content = dir ([TrainDatabasePath,stk]);
        % nface = size (folder_content,1);

        % disp(nface);
        for j = 1 :  nface
            str = int2str(j);
            str = strcat('\',str,'.bmp');
            str = strcat('\',int2str(i),str);
            str = strcat(TrainDatabasePath, str); 
            T(:,img_idx) = LoadImage(str);
            C(img_idx) = i;
            img_idx = img_idx + 1;
        end

    end
    fprintf(1, 'Database loaded: %d x %d\n', size(T, 1), size(T, 2));
end
