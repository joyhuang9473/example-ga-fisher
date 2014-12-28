function [ OutputName ] = FaceRec(W, Xt, Ct)
    
%     if exist('name.mat', 'file');
%         load('name.mat');
%         fprintf(1, 'name.mat is loaded');
        
    if exist('e_name_vl.mat', 'file');
        load('e_name_vl.mat');
        fprintf(1, 'e_name_vl.mat is loaded');     
            
    else
        name = cell(1,49);
        for i = 1:49
            name{i} = sprintf('class %02d', i);
        end
         e_name_vl = cell(1,49);
         for i = 1:49
             e_name_vl{i} = sprintf('class %02d', i);
         end
    end
    
    while (1 == 1)
        choice=menu('Face Recognition',...
                    '      Load Image      ',...
                    '      Capture Now     ',...
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
            OutputName = e_name_vl{n};
            
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

        if (choice == 2) % Open webcam
            camList = webcamlist; %The webcamlist function provides a cell array of webcams on the current system that MATLAB can access.
            cam = webcam(1);  % Connect to the first webcam of your computer.
            preview(cam); % Open a Video Preview window.
            
            img = snapshot(cam);% Capture the image
            image(img);
                        
        end
        
        if (choice == 3) 
            clear cam;  % Once the camera connection is no longer needed, clear the associated variable.
            close all;
            return;
        end

    end    
end

