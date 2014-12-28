function main
    try
        load('coeff.mat');
    catch
        Train = [1 21 41 61 81];
        Test = 1:100; Test(Train) = [];
        gaCoef = [200 400];
    end

    while (1==1)
        choice=menu('Face Recognition System',...
                    'Set System Coefficient',...
                    'Calculate Recognition Rate',...
                    'Train System',...
                    'Face Recognition',...
                    'Exit');
        
        if (choice == 1)
            %% Set Training/Testing
            prompt1 = 'Pictures for training? (per person)';
            prompt2 = 'Pictures for testing? (per person)';
            prompt3 = 'Population & Generation?';
            coef = inputdlg({prompt1, prompt2, prompt3});
            [Train, Test, gaCoef] = parsecoeff(coef);
            save('coeff.mat', 'Train', 'Test', 'gaCoef');
        end

        if (choice == 2)
            %% Calculate Recognition Rate
%             try
                load('train.mat', 'Wopt', 'Xt', 'Ct');
                rec_rate = CalRecRate([], Test, Wopt, Xt, Ct);
                msgbox(sprintf('%.2f%%', rec_rate * 100), 'Recognition Rate');
%             catch
%                 msgbox('Please train the system first', 'Error');
%             end
        end
        

        if (choice == 3)
            %% Train System
            [Xt, Ct] = TrainDatabase([], Train);
            [Wopt, ~, ~] = GAFisherCore(Xt, Ct, gaCoef);
            save('train.mat', 'Wopt', 'Xt', 'Ct');
        end

        if (choice == 4)
            %% Face Recognition
%             try
                load('train.mat', 'Wopt', 'Xt', 'Ct');
                FaceRec(Wopt, Xt, Ct);
%             catch
%                 msgbox('Please train the system first', 'Error');
%             end
        end

        if (choice == 5)
            %% Exit
            close all;
            return;
        end

    end
end