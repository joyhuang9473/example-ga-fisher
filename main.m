function main
    try
        if ~cvprcheck
            return;
        end
        load('coeff.mat', 'Train', 'Test', 'GAcoef');
    catch
        Train = [1 2 3 37 69];
        Test = 1:100; Test(Train) = [];
        GAcoef = [40 40 1];
    end
    load_src = 'train.mat';
    save_dst = 'train.mat';

    while (1==1)
        choice=menu('Face Recognition System',...
                    'Set System Coefficient',...
                    'Train System',...
                    'Calculate Recognition Rate',...
                    'Face Recognition',...
                    'Exit');
        
        if (choice == 1)
            %% Set Training/Testing, see parsecoeff.m for more details
            try
                prompt1 = 'Pictures for training? (per person)';
                prompt2 = 'Pictures for testing? (per person)';
                prompt3 = 'Population & Generation & GPU?';
                coef = inputdlg({prompt1, prompt2, prompt3});
                [Train, Test, GAcoef] = parsecoeff(coef);
                save('coeff.mat', 'Train', 'Test', 'GAcoef');
            catch e
                disp(e);
                msgbox('Bad coeff setting', 'Error');
            end
        end

        if (choice == 2)
            %% Train System
            try
                [Xt, Ct] = TrainDatabase([], Train);
                trainT = tic;
                [Wopt, ~, ~] = GAFisherCore(Xt, Ct, GAcoef);
                trainT = toc(trainT);
                save(save_dst, 'Wopt', 'Xt', 'Ct');
                detail = sprintf('Time: %s', calctime(trainT));
                detail = sprintf('%s\nSave: %s', detail, save_dst);
                msgbox(detail, 'Done!');
            catch e
                disp(e);
                msgbox('Bad training!', 'Error');
            end
        end

        if (choice == 3)
            %% Calculate Recognition Rate
            try
                load(load_src, 'Wopt', 'Xt', 'Ct');
                rec_rate = CalRecRate([], Test, Wopt, Xt, Ct);
                msgbox(sprintf('%.2f%%', rec_rate * 100), 'Recognition Rate');
            catch e
                disp(e);
                msgbox('Please train the system first', 'Error');
            end
        end
        
        if (choice == 4)
            %% Face Recognition
            try
                load(load_src, 'Wopt', 'Xt', 'Ct');
                FaceRec(Wopt, Xt, Ct);
            catch e
                disp(e);
                msgbox('Please train the system first', 'Error');
            end
        end

        if (choice == 5)
            %% Exit
            close all;
            return;
        end

    end
end