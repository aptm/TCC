
   DATABASE_ROOT = 'D:\Documents\TCC\matlab\dummy\'
%    DATABASE_ROOT = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';
    SAVEWORKSPACE_PATH = 'D:\Documents\TCC\matlab\saveme\'

% Folder Names
PAD_DIR    = 'padded/';
AUG_DIR    = 'aug/';
MIDDLE_DIR = 'sets/';
TRAIN_DIR  = 'train/';
VALID_DIR  = 'valid/';
TEST_DIR   = 'test/';

% Sequence of Database dir and Functions for reading database
%  ordered by experiment
DATABASE_DIR = { PAD_DIR , ...
                AUG_DIR, AUG_DIR,...
                AUG_DIR, AUG_DIR, ...
                AUG_DIR, AUG_DIR};

FcnReadExp = {  @(filename)customreader(filename),...
                @(filename)customreader(filename)};

%%
for m = 1:2    
    exp_name = EXP_TITLE{m};
    savedir = strcat(SAVEWORKSPACE_PATH,exp_name,'\');
    mkdir(savedir)
    
    disp('--------------------------------------------')
    disp(['Experimento: ' exp_name])
    disp(['DATABASE_DIR: ' DATABASE_DIR{m}])
    disp(['SAVE_DIR: ' savedir])
    % LOAD DATASET ONLY THE 2 FIRST EXPERIMENTS (AFTER IT'S ALL THE SAME)
    if(m<=2)
       %Read Database path
       DATABASE_SPEC =  DATABASE_DIR{m};          
       TRAIN_PATH  = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC TRAIN_DIR];
       VALID_PATH  = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC VALID_DIR];
       TEST_PATH   = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC TEST_DIR]; 
    
       trainingImages   = imageDatastore(TRAIN_PATH,'LabelSource','foldernames', 'IncludeSubfolders',true)
       validationImages = imageDatastore(VALID_PATH,'LabelSource','foldernames', 'IncludeSubfolders',true)                            
       testingImages    = imageDatastore(TEST_PATH,'LabelSource','foldernames', 'IncludeSubfolders',true)
    end    
    
    trainingImages.ReadFcn   = FcnReadExp{m};
    validationImages.ReadFcn = FcnReadExp{m};
    testingImages.ReadFcn    = FcnReadExp{m};
    for k = 1:length(trainingImages.Files)
        imwrite(readimage(trainingImages,k),trainingImages.Files{k});
    end
    
    for k = 1:length(validationImages.Files)
        imwrite(readimage(validationImages,k),validationImages.Files{k});
    end
    
    for k = 1:length(testingImages.Files)
        imwrite(readimage(testingImages,k),testingImages.Files{k});
    end
end

function data = customreader(filename)
    im = imread(filename);     
    data = imresize(im,[227 227]);
end
