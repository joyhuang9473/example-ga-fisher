function rec_rate = CalRecRate(TrainDatabasePath, test_nface, W, Xt, Ct)
    disp('Calculate recognition rate...');

    no_folder = 49;
    
    if ~exist('TrainDatabasePath', 'var') || isempty(TrainDatabasePath)
        TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
    
    Xq = zeros(80 * 60, no_folder * test_nface);
    Cq = zeros(1, size(Xq, 2));
    img_idx = 1;
    for i = 1 : no_folder
        fprintf(1, 'Class %d:\n', i);
        for j = 100-test_nface+1 : 100
            str = int2str(j);
            str = strcat('\',str,'.bmp');
            str = strcat('\',int2str(i),str);
            str = strcat(TrainDatabasePath,str); 
            Xq(:, img_idx) = LoadImage(str);
            Cq(img_idx) = i;
            img_idx = img_idx+1;
        end
    end 
    Yt = cvLdaProj(Xt, W);
    Yq = cvLdaProj(Xq, W);
    [Classified, ~] = cvKnn(Yq, Yt, Ct, 1);    
    rec_rate = sum(Classified == Cq) / size(Cq,2);
    fprintf(1, 'Recognition Rate: %.2f%%\n', rec_rate * 100);
%   save RR;

end


