function main
    % close all
    % clear all
    % clc
    % moporgic

    prompt = 'How many pictures for taining?(per person) ';
    train_nface = input(prompt);
    train_nface = int8(train_nface);

    prompt = 'How many pictures for test?(per person) ';
    test_nface = input(prompt);
    test_nface = int8(test_nface);
    
    while (1==1)
        choice=menu('Face Attendance System',...
                    'Create Database of Faces',...
                    'Calculate recognition rate',...
                    'Train System',...
                    'Face Recognition',...
                    'Exit');

        if (choice ==1)
            clear all;
            CreateDatabase;
        end

       if (choice == 2)
            if exist('train.mat');
                load train;
            end
            CalRecRate(m, A, Eigenfaces, test_nface, train_nface);
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
