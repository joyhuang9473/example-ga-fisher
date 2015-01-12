function [W, X, C, R] = GAFisherDemo(Train, Test, GAcoef)
%%	function [W, X, C, R] = GAFisherDemo(Train, Test, GAcoef)
%   train a GA-Fisher system and test it
    if ~exist('Train', 'var') || isempty(Train)
        Train = [1 2 3 37 69];
    end
    if ~exist('GAcoef', 'var') || isempty(GAcoef)
        GAcoef = [40 40];
    end
    
    [X, C] = TrainDatabase('TrainDatabase', Train);
    [W, X, C] = GAFisherCore(X, C, GAcoef);
    
    if exist('Test', 'var')
        if isempty(Test)
            Test = Train;
        end
        R = CalRecRate('TrainDatabase', Test, W, X, C, true);
    else
        R = 0;
    end
end