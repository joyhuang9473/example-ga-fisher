function [ OutputName ] = FaceRec(Wopt, M, U)
    % cd TestImage;
    
    while (1 == 1)
        choice=menu('Face Recognition',...
                    'Input Image From File',...
                    'Capture Now',...
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
            image = imresize(image, [60 80]);

            figure,
            imshow(image);
            % saveimage(capcha);
        end
        
        if (choice == 2)
            try cd TestImage;close all; end;
            capturenow;
        end
        
        if (choice == 3)
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
            OutputName = name(1,n);
            name_str = strcat('Equivalent Image : ', OutputName);
            title(name_str);
            
            disp('Student No');
            disp(int2str(n));
        end

        if (choice == 4) 
            clc; 
            close all;
            return;
        end

    end    
end

