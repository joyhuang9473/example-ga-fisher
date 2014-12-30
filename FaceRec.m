function [ OutputName ] = FaceRec(Wopt, Xt, Ct)

    % loading name resources
    [name_show, e_name_vl] = initname();
    % making projection & resize infomation
    Yt = cvLdaProj(Xt, Wopt);
    resize_dim = [80 60];
    resize = resize_dim(1) * resize_dim(2);
    
    while (true)
        choice=menu('Face Recognition',...
                    '      Load Image      ',...
                    '      Capture Now     ',...
                    'Exit');
                
        if (choice ==1)
            Xq = zeros(80 * 60, 1);
            InputName = imgetfile();
            [Xq(:,1), test] = LoadImage(InputName);
            
            %% recognition
            Yq = cvLdaProj(Xq, Wopt);
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
            fprintf(1, 'real-time recognizing system is now working...\n');
            try
                format = {'MJPG_640x480', 'RGB24_640x480'};
                for i = 1:length(format)
                    try
                        obj = imaq.VideoDevice('winvideo', 1 ,format{i},'ReturnedDataType','uint8');
                        fprintf(1, 'webcam is ready. mode: %s\n', format{i});
                        break;
                    catch
                        clear obj;
                    end
                end
                set(obj,'ReturnedColorSpace','rgb');
                % preview(obj);
                figure('menubar','none','tag','webcam');
                             
                % Create a cascade detector object.
                faceDetector = vision.CascadeObjectDetector();           
                while(true)
                    frame = step(obj);
                    bboxes  = step(faceDetector, frame); % Detect faces.
                    if size(bboxes, 1) > 0
                        try
                            % some faces have been detected
                            % class = Recognition(Wopt, Xt, Ct, frame, bboxes);
                            image = rgb2gray(frame);
                            Xq = zeros(resize, size(bboxes, 1));
                            for i = 1:size(Xq, 2)
                                face = imcrop(image, bboxes(i,:));
                                face = imresize(face, resize_dim);
                                Xq(:,i) = reshape(face', resize, 1);
                            end

                            % Yq = cvLdaProj(Xq, Wopt);
                            % [class, ~] = cvKnn(Yq, Yt, Ct, 1);
                            Yq = Wopt.'*Xq;
                            V = ~isnan(Yq); Yq(~V) = 0; % V = ones(D, N); 
                            U = ~isnan(Yt); Yt(~U) = 0; % U = ones(D, P); 
                            D = abs(Yq'.^2*U - 2*Yq'*Yt + V'*Yt.^2);
                            [~, index] = min(D, [], 2);
                            class = Ct(index);

                            % generate the result
                            label = cell(1, length(class));
                            for i = 1:length(class)
                                label{i} = name_show{class(i)};
                            end
                            % Draw the returned bounding box around the detected face.
                            frame = insertObjectAnnotation(frame,'rectangle',bboxes,label);
                        catch e
                            fprintf(2, 'error in real-time recognition.\n');
                            disp(e);
                        end
                    end
                    
                    imshow(frame,'border','tight');
%                     f = findobj('tag','webcam');
%                     if(isempty(f))
%                         close(gcf);
%                         break;
%                     end
                    pause(0.05);
                end
            catch
            end
            
            try
                release(obj);
                clear obj;
            catch
            end
        end
        
        if (choice == 3)
            close all;
            return;
        end

    end    
end

function [name_show, e_name_vl, name] = initname()
    % loading name resources
    op = 0;
    try
        load('name.mat', 'name');
        fprintf(1, 'name.mat is loaded\n');
        op = 1;
    catch
        name = cell(1,49);
        for i = 1:49
            name{i} = sprintf('CLASS %02d', i);
        end
    end
    try
        load('e_name_vl.mat', 'e_name_vl');
        fprintf(1, 'e_name_vl.mat is loaded\n');
        op = 2;
    catch
        e_name_vl = name;
    end
    if op == 2
        name_show = cell(1,49);
        for i = 1:49
%             name_show{i} = sprintf('%s [%s]', e_name_vl{i}, name{i});
            name_show{i} = sprintf('%s [CLASS %02d]', e_name_vl{i}, i);
        end
    else
        name_show = name;
    end
end