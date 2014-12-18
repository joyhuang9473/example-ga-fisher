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
            [Xq(:,1), test] = LoadImage(InputName);
            
            %% recognition
            Yq = cvLdaProj(Xq, W);
            Yt = cvLdaProj(Xt, W);
            [Classified, ~] = cvKnn(Yq, Yt, Ct, 1);
            n = Classified(1);
            
            %% display result
            imgpath = strcat('TrainDatabase\',int2str(n),'\1.bmp');
            [~, recog_result] = LoadImage(imgpath);
            OutputName = name{n};
            
            name_idx = regexp(InputName, '.[0-9]+.[0-9]+.(bmp|BMP)');
            if ~isempty(name_idx)
                InputName = strrep(InputName(name_idx:end),'\', '/');
            end
            subplot(121), imshow(test);
            title(InputName);
            
            subplot(122), imshow(recog_result);
            title(OutputName);
            
            fprintf(1, 'Student No %d: %s\n', n, OutputName);
        end

        if (choice == 2) 
            close all;
            return;
        end

    end    
end

