function [ OutputName ] = FaceRec(m, A, Eigenfaces,train_nface)
cd TestImage;
while (1==1)
    choice=menu('Face Recognition',...
                'Input Image From File',...
                'Capture Now',...
                'Recognition',...
                'Exit');
    if (choice ==1)
       try cd TestImage;close all; end; 
        ChooseFile = imgetfile;

        %To detect Face
        FDetect = vision.CascadeObjectDetector;
        capcha = imread(ChooseFile);

        %Returns Bounding Box values based on number of objects
        BB = step(FDetect,capcha);
        % step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].

        capcha = imcrop(capcha,BB);
        capcha = imresize(capcha, [250 250]);

        figure,
        imshow(capcha);
        saveimage(capcha);
    end
    if (choice == 2)
        try cd TestImage;close all; end;
        capturenow;

    end    
    if (choice == 3)
       OutputName=Recognition(m, A, Eigenfaces);
        n=((OutputName+1)/train_nface); % Calculate which person is the correct answer

       
       im=imread('InputImage.bmp');
       cd ..;
       img=strcat('TrainDatabase\',int2str(n),'\1.bmp');
       SelectedImage=imread(img);
       subplot(121);
       imshow(im)
    title('Test Image');
    subplot(122),imshow(SelectedImage);
    title('Equivalent Image');
       disp('Student No');
       disp(int2str(n));
       
    end
     
   if (choice == 4) 
       clc; 
        close all;
        return;
    end    
end

