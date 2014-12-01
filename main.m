function main
    train_nface = 10;
    test_nface = 90;

    while (1==1)
        choice=menu('Face Attendance System',...
                    'Set Training/Testing',...
                    'Calculate recognition rate',...
                    'Train System',...
                    'Face Recognition',...
                    'Exit');

        if (choice ==1)
            %clear all;
            %CreateDatabase;
            prompt1 = 'How many pictures for training? (per person)';
            prompt2 = 'How many pictures for testing? (per person)';
            coef = inputdlg({prompt1, prompt2});
            if ~isempty(coef)
                train_nface = int8(str2double(coef{1}));
                test_nface = int8(str2double(coef{2}));
            end
            fprintf(1, 'training: %d  testing: %d\n', train_nface, test_nface);
        end

       if (choice == 2)
            if exist('train.mat', 'file');
                load('train.mat');
            end
            % CalRecRate(m, A, Eigenfaces, test_nface, train_nface);
            CalRecRate([], test_nface, Wopt, Xt, Ct);
        end
        

        if (choice == 3)
            [Wopt, Xt, Ct] = Trainit(train_nface);
            save('train.mat', 'Wopt', 'Xt', 'Ct');
        end

        if (choice == 4)
            if exist('train.mat', 'file');
                load('train.mat');
            end
            FaceRec(Wopt, Xt, Ct);
        end

        if (choice == 5)
            clc;
            close all;
            return;
        end

    end
end
