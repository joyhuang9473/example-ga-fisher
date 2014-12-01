function [ ] = CalRecRate(m, A, Eigenfaces, test_nface, train_nface)
    disp('Calculate recognition rate...');
%     cd TestImage

    no_folder = 10;
    nface = test_nface;    % Choose how many pictures of one person to train.
    correct = 0;
    TrainDatabasePath = uigetdir('E:\facerec\TestImage\', 'Select test database' );
    
    for i = 1 : no_folder
         disp(nface);
        for j = (100-nface) :  100
            str = int2str(j);
            str = strcat('\',str,'.bmp');
            str = strcat('\',int2str(i),str);
            str = strcat(TrainDatabasePath,str); 
            img = imread(str);
            imwrite(img,'InputImage.bmp');
            
            %-----------------------------------------
            ProjectedImages = [];
            Train_Number = size(Eigenfaces,2);
            for i = 1 : Train_Number
                temp = Eigenfaces'*A(:,i); % Projection of centered images into facespace
                ProjectedImages = [ProjectedImages temp]; 
            end

            %%%%%%%%%%%%%%%%%%%%%%%% Extracting the PCA features from test image
            InputImage = imread('InputImage.bmp');
            temp = InputImage(:,:,1);

            [irow icol] = size(temp);
            InImage = reshape(temp',irow*icol,1);
            Difference = double(InImage)-m; % Centered test image
            ProjectedTestImage = Eigenfaces'*Difference; % Test image feature vector

            %%%%%%%%%%%%%%%%%%%%%%%% Calculating Euclidean distances 
            % Euclidean distances between the projected test image and the projection
            % of all centered training images are calculated. Test image is
            % supposed to have minimum distance with its corresponding image in the
            % training database.

            Euc_dist = [];
            for i = 1 : Train_Number
                q = ProjectedImages(:,i);
                temp = ( norm( ProjectedTestImage - q ) )^2;
                Euc_dist = [Euc_dist temp];
            end

            [Euc_dist_min , Recognized_index] = min(Euc_dist);
            OutputName = (Recognized_index);

            %------------------------------------------------------
            
            n=((OutputName+1)/train_nface); % Calculate which person is the correct answer
            if n == i
                correct = correct +1;
            end   
                        
        end
    end 
    rec_rate = correct/(no_folder*nface)
    
save RR;

end


