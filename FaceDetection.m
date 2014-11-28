%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = imread('26.bmp');

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
% step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].
cap_face = imcrop(I,BB);
cap_face = imresize(cap_face, [250 250])

figure,
imshow(cap_face);


figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;