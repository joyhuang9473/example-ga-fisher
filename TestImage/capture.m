function [capcha]= capture(vid)
    
    %To detect Face
    FDetect = vision.CascadeObjectDetector;
    
    capcha=getsnapshot(vid);
    capcha=ycbcr2rgb(capcha);
    
    %Returns Bounding Box values based on number of objects
    BB = step(FDetect,capcha);
    % step(Detector,I) returns Bounding Box value that contains [x,y,Height,Width].

    capcha = imcrop(I,BB);
    capcha = imresize(capcha, [250 250]);
    
    % capcha=imcrop(capcha,[180,20,280,380]);
    imshow(capcha);
end

