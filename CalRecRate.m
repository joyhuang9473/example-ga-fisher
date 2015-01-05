function rec_rate = CalRecRate(DatabasePath, TestImages, W, Xt, Ct, option)
    disp('Calculate recognition rate...');
    if ~exist('DatabasePath', 'var') || isempty(DatabasePath)
        DatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
    if ~exist('option', 'var') || length(option) < 1
        option = [false false];
    end
    batch = logical(option(1));
    no_folder = 49;
    [td1, td2] = size(TestImages);
    if td1 == 1 || td2 == 1;
        if td1 == 1 && td2 == 1
            TestImages = (100-TestImages+1):TestImages;
        elseif td2 == 1
            TestImages = TestImages';
        end
        train = zeros(no_folder, length(TestImages));
        for i = 1:no_folder
            train(i,:) = TestImages;
        end
        TestImages = train;
    end
    rec_pass = 0; total_test = 0;
    Yt = cvLdaProj(Xt, W);
    for i = 1:size(TestImages,1)
        testimg = find(TestImages(i,:));
        testnum = length(testimg);
        fprintf(1, 'Class %d: %d images\n', i, testnum);
        if batch
            Xq = zeros(size(Xt, 1), testnum);
            for s = 1:testnum
                img = sprintf('%s\\%d\\%d.bmp',DatabasePath,i,TestImages(i,s));
                [Xq(:,s), ~] = LoadImage(img, [], 1);
            end
            Yq = cvLdaProj(Xq, W);
            [class, ~] = cvKnn(Yq, Yt, Ct, 1);
            OK = sum(class == i);
            total_test = total_test + length(class);
            rec_pass = rec_pass + OK;
            fprintf(1, '\b -> %d passed (%.2f%% / %.2f%%)\n', OK,...
                OK / length(class) * 100, rec_pass / total_test * 100);
        else
            Xq = zeros(size(Xt, 1), 1);
            for s = 1:testnum
                total_test = total_test + 1;
                img = sprintf('%s\\%d\\%d.bmp',DatabasePath,i,TestImages(i,s));
                fprintf(1, '-recognizing %s... ', img);
                [Xq(:,1), ~] = LoadImage(img, [], 1);
                Yq = cvLdaProj(Xq, W);
                [class, ~] = cvKnn(Yq, Yt, Ct, 1);
                if class(1) == i
                    fprintf(1, 'OK\n');
                    rec_pass = rec_pass + 1;
                else
                    fprintf(1, 'BAD (%d)\n', class(1));
                end
            end
        end
    end
    
    rec_rate = rec_pass / total_test;
    
    fprintf(1, 'Pass/Total: %d/%d\n', rec_pass, total_test);
    fprintf(1, 'Recognition Rate: %.2f%%\n', rec_rate * 100);

end