function rec_rate = CalRecRate(TrainDatabasePath, test_nface, W, Xt, Ct)
    disp('Calculate recognition rate...');
    if ~exist('TrainDatabasePath', 'var') || isempty(TrainDatabasePath)
        TrainDatabasePath = uigetdir('TrainDatabase\', 'Select training database path' );
    end
    
    no_folder = 49;
    total_test = no_folder * test_nface;
%     Xq = zeros(size(Xt,1), total_test);
%     Cq = zeros(1, size(Xq, 2));
    rec_pass = 0;
    Yt = cvLdaProj(Xt, W);
    Xq = zeros(size(Xt, 1), 1);
    for i = 1 : no_folder
        fprintf(1, 'Class %d:\n', i);
        for j = 100-test_nface+1 : 100
            str = int2str(j);
            str = strcat('\',str,'.bmp');
            str = strcat('\',int2str(i),str);
            str = strcat(TrainDatabasePath,str); 
            
%             [Xq(:,i), ~] = LoadImage(str, []);
%             Cq(i) = i;
            fprintf(1, '-recognizing %s... ', str);
            [Xq(:,1), ~] = LoadImage(str, [], 1);
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
    
%     Yq = cvLdaProj(Xq, W);
%     Yt = cvLdaProj(Xt, W);
%     [Classified, ~] = cvKnn(Yq, Yt, Ct, 1);
%     rec_rate = sum(Classified == Cq) / size(Cq,2);
    rec_rate = rec_pass / total_test;
    
    fprintf(1, 'Recognition Rate: %.2f%%\n', rec_rate * 100);

end


