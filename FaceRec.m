function [ OutputName ] = FaceRec(Wopt, ~, U)
    % cd TestImage;
    
    while (1 == 1)
        choice=menu('Face Recognition',...
                    'Load Image File',...
                    'Recognition',...
                    'Exit');
        if (choice ==1)
            % try cd TestImage; close all; end; 
            ChooseFile = imgetfile;

            %To detect Face
            FDetect = vision.CascadeObjectDetector;
            image = imread(ChooseFile);

            %Returns Bounding Box values based on number of objects
            BB = step(FDetect,image);
            % step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].

            image = imcrop(image, BB);
            figure, imshow(image);
            image = imresize(image, [80 60]);

            % saveimage(capcha);
        end
        
%         if (choice == 2)
%             try cd TestImage;close all; end;
%             capturenow;
%         end
        
        if (choice == 2)
            if exist('name.mat', 'var');
                load('name.mat');
            else
                name = 1:49;
            end
            % OutputName=Recognition(m, A, Eigenfaces);
            % n=((OutputName+1)/train_nface); % Calculate which person is the correct answer
            n = Recognition(Wopt, U, image);
            img=strcat('TrainDatabase\',int2str(n),'\1.bmp');
            SelectedImage = imread(img);
            subplot(121);
            imshow(image)
            title('Test Image');
            subplot(122),imshow(SelectedImage);
            n = int8(n);
            OutputName = name(n);
            name_str = strcat('Equivalent Image : ', OutputName);
            title(name_str);
            
            disp('Student No');
            disp(int2str(n));
        end

        if (choice == 3) 
            clc; 
            close all;
            return;
        end

    end    
end

