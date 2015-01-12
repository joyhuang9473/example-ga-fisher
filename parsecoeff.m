function [Train, Test, GAcoef] = parsecoeff(coef)
%%	function [Train, Test, GAcoef] = parsecoeff(coef)
%   parse string coefficient
%   coef: cell array, length = 3
%         coef{1} = training label, '1 2 3 4 5' or '1 50 60 70 80'
%         coef{2} = testing labe, same as training label format
%         coef{3} = GApca coefficient, Gen & Popu & GPU, default is '40 40 1'
    %% Train
    if ~isempty(coef{1})
        array = strsplit(coef{1});
        if length(array) > 1
            Train = zeros(1, length(array));
            for i = 1:length(Train)
                Train(i) = str2double(array{i});
            end
        else
            Train = zeros(1, str2double(array{1}));
            off = floor(100 / length(Train));
            for i = 1:length(Train)
                Train(i) = 1 + (i-1) * off;
            end
        end
        Train = sort(Train);
    end
    %% Test
    if ~isempty(coef{2})
        array = strsplit(coef{2});
        if length(array) > 1
            Test = zeros(1, length(array));
            for i = 1:length(Test)
                Test(i) = str2double(array{i});
            end
        else
            Test = 1:100;
            Test(Train) = [];
            Test = Test(randperm(length(Test)));
            Test = Test(1:str2double(array{1}));
        end
        Test = sort(Test);
    else
        Test = 1:100;
        Test(Train) = [];
    end
    %% GA Coef
    if ~isempty(coef{3})
        array = strsplit(coef{3});
        GAcoef = [str2double(array{1}) str2double(array{2}) str2double(array{3})];
        GAcoef(1) = min(GAcoef(1), 999);
        GAcoef(2) = min(GAcoef(2), 999);
        GAcoef(3) = logical(GAcoef(3));
    else
        GAcoef = [40 40 1];
    end
    %% print result
    fprintf(1, 'Training Images (%d): \n', length(Train));
    for i = 1:length(Train)
        fprintf(1, '\b %d\n', Train(i));
    end
    fprintf(1, 'Testing Images (%d): \n', length(Test));
    for i = 1:length(Test)
        fprintf(1, '\b %d\n', Test(i));
    end
    fprintf(1, 'GA-PCA: [%d %d %d]\n', GAcoef(1), GAcoef(2), GAcoef(3));
end