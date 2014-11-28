 cd TestImage;close all; 
 
 %To detect Face
FDetect = vision.CascadeObjectDetector;
 for i =1 : 10
 ChooseFile = imgetfile;       

capcha = imread(ChooseFile);

%Returns Bounding Box values based on number of objects
CC = step(FDetect,capcha);
% step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].

capcha = imcrop(capcha,CC);
capcha = imresize(capcha, [250 250]);

figure,
imshow(capcha);
 end
% 
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
% end
% title('Face Detection');
% hold off;