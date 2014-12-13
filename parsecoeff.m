function [Train, Test, gaCoef] = parsecoeff(coef)
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
        array = strsplit(coef{1});
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
        gaCoef = [str2double(array{1}) str2double(array{2})];
        gaCoef(1) = min(gaCoef(1), 999);
        gaCoef(2) = min(gaCoef(2), 999);
    else
        gaCoef = [200 400];
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
    fprintf(1, 'GA-PCA: %d %d\n', gaCoef(1), gaCoef(2));
end