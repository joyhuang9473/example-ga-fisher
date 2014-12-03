function rec_rate = CalRecRate(DatabasePath, TestImages, W, Xt, Ct)
    disp('Calculate recognition rate...');
    if ~exist('TrainDatabasePath', 'var') || isempty(DatabasePath)
        DatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
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
    Xq = zeros(size(Xt, 1), 1);
    for i = 1:size(TestImages,1)
        fprintf(1, 'Class %d:\n', i);
        testimg = find(TestImages(i,:));
        for s = 1:length(testimg)
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
    
    rec_rate = rec_pass / total_test;
    
    fprintf(1, 'Pass/Total: %d/%d\n', rec_pass, total_test);
    fprintf(1, 'Recognition Rate: %.2f%%\n', rec_rate * 100);

end


