%% Separates the augmented dataset into training testing and validadion folder

PC = 'luc'; %else PC = 'Luc';
date = '23-07';

if(strcmp(PC,'Ana'))  
%     DATABASE_ROOT = 'D:\Documents\TCC\matlab\dummy\'
    DATABASE_ROOT = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';
    filepath2save = 'D:\Documents\TCC\matlab\saveme\'
else
    DATABASE_ROOT = 'E:/UFCG/ExperimentosAna/database/MasseyUniversity HandImages ASL Dataset/';
    filepath2save = 'C:\Users\Luciana\Dropbox\UFCG\ExperimentosAna\23-07\';
end

PAD_DIR = 'padded/';
AUG_DIR    = 'aug/';
MIDDLE_DIR = 'sets/';
TRAIN_DIR = 'train/';
VALID_DIR = 'valid/';
TEST_DIR  = 'test/';

DATABASE_DIR= { PAD_DIR , ...
                AUG_DIR};

for m = 1:2
    %write path
    DATABASE_SPEC =  DATABASE_DIR{m}          
    TRAIN_PATH  = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC TRAIN_DIR];
    VALID_PATH  = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC VALID_DIR];
    TEST_PATH   = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC TEST_DIR]; 
    
    % read path
    DATABASE_PATH = [DATABASE_ROOT DATABASE_SPEC];
    
    %% Create folder to save workspace
    mkdir(filepath2save)

    %% Create folders for train, validation and test
    % as well as the label folders
    mkdir(TRAIN_PATH)
    mkdir(VALID_PATH)
    mkdir(TEST_PATH)

    labels = ['0123456789abcdefghijklmnopqrstuvwxyz'];
%     labels = 'bc'
    for i = 1:length(labels)
        mkdir([TRAIN_PATH labels(i) '/'])
        mkdir([VALID_PATH labels(i) '/'])
        mkdir([TEST_PATH  labels(i) '/'])
    end

    %% Load AUG
    images = imageDatastore(DATABASE_PATH,'LabelSource','foldernames', ...
                            'IncludeSubfolders',true);

    L = length(images.Files);
    LabelCount = countEachLabel(images)
    %% split the dataset
    [trainingImages,validationImages,testingImages] = splitEachLabel(images,0.6,0.2,'randomized')

    %% information
%     TA_labels = countEachLabel(trainingImages)
%     VA_labels = countEachLabel(validationImages)
%     TE_labels = countEachLabel(testingImages)

    %% Save
    le= length(DATABASE_PATH);

    for k = 1:length(testingImages.Files)
        im = readimage(testingImages,k);
        filename = testingImages.Files{k}(le:end);
        imwrite(im,[TEST_PATH filename]);    
    end
    for k = 1:length(validationImages.Files)   
        im = readimage(validationImages,k);
        filename = validationImages.Files{k}(le:end);
        imwrite(im, [VALID_PATH filename]);
    end
    for k = 1:length(trainingImages.Files)    
        im = readimage(trainingImages,k);
        filename = trainingImages.Files{k}(le:end);
        imwrite(im,[TRAIN_PATH filename]);
    end
end
