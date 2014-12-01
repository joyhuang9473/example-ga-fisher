function [ OutputName ] = FaceRec(W, Xt, Ct)
    if exist('name.mat', 'file');
        load('name.mat');
        fprintf(1, 'name.mat is loaded');
    else
        name = cell(1,49);
        for i = 1:49
            name{i} = sprintf('class %02d', i);
        end
    end
    
    while (1 == 1)
        choice=menu('Face Recognition',...
                    '      Load Image      ',...
                    'Exit');
                
        if (choice ==1)
            Xq = zeros(80 * 60, 1);
            InputName = imgetfile();
            [Xq(:,1), image] = LoadImage(InputName);
            
            %% recognition
            Yq = cvLdaProj(Xq, W);
            Yt = cvLdaProj(Xt, W);
            [Classified, ~] = cvKnn(Yq, Yt, Ct, 1);
            n = Classified(1);
            
            %% display result
            result_path=strcat('TrainDatabase\',int2str(n),'\1.bmp');
            [~, result_image] = LoadImage(result_path);
            
            OutputName = name{n};
            
            subplot(121), imshow(image)
            title('Test Image');
            
            subplot(122),imshow(result_image);
            title(OutputName);
            
            fprintf(1, 'Student No %d: %s\n', n, OutputName);
        end

        if (choice == 2) 
            close all;
            return;
        end
    end    
end

