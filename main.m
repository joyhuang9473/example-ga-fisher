function main
    % close all
    % clear all
    % clc
    % moporgic

    train_nface = 5; % Choose how many pictures of one person to train.

    while (1==1)
        choice=menu('Face Attendance System',...
                    'Create Database of Faces',...
                    'Delete DataBase',...
                    'Train System',...
                    'Face Recognition',...
                    'Exit');

        if (choice ==1)
            clear all;
            CreateDatabase;
        end

        if (choice == 2)
            DeleteDatabase;
        end

        if (choice == 3)
            [Wopt, M, U] = Trainit(train_nface);
            save('train.mat', 'Wopt', 'M', 'U');
        end

        if (choice == 4)
            if exist('train.mat', 'var');
                load('train.mat', 'Wopt', 'M', 'U');
            end
            FaceRec(Wopt, M, U);
        end

        if (choice == 5)
            clc;
            close all;
            return;
        end

    end
end