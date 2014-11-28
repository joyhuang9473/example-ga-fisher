 cd TestImage;close all; 
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

% 
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
% end
% title('Face Detection');
% hold off;