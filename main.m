function main
    try
        load('coeff.mat');
    catch
        Train = [1 2 3 37 69];
        Test = 1:100; Test(Train) = [];
        gaCoef = [40 40 1];
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
<<<<<<< HEAD
            catch e
                disp(e);
                msgbox('Please train the system first', 'Error');
            end
=======
%             catch
%                 msgbox('Please train the system first', 'Error');
%             end
>>>>>>> 3f88aeb71dca484e1a6d1118791c41ac3fd18367
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
<<<<<<< HEAD
            catch e
                disp(e);
                msgbox('Please train the system first', 'Error');
            end
=======
%             catch
%                 msgbox('Please train the system first', 'Error');
%             end
>>>>>>> 3f88aeb71dca484e1a6d1118791c41ac3fd18367
        end

        if (choice == 5)
            %% Exit
            close all;
            return;
        end

    end
end