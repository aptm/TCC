% %% Experimentos CNN reconhecimento de gestos
% % Autor: Ana
% % Transfer Learning Using AlexNet
% % MU_HandImages Dataset
% 
% PC = 'luc'; % 'Ana' ou 'Luc';
% date = '23-07';
% 
% if(strcmp(PC,'Ana'))  
% %   DATABASE_ROOT = 'D:\Documents\TCC\matlab\dummy\'
%     DATABASE_ROOT = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';
%     SAVEWORKSPACE_PATH = 'D:\Documents\TCC\matlab\saveme\'
% else
%     DATABASE_PATH = 'E:/UFCG/ExperimentosAna/database/MasseyUniversity HandImages ASL Dataset/';
%     SAVEWORKSPACE_PATH = 'C:\Users\Luciana\Dropbox\UFCG\ExperimentosAna\23-07\';
% end  
% 
% %% Create folder to save workspace
% mkdir(SAVEWORKSPACE_PATH)
% 
% %% Save command window from now on
% diary(strcat(SAVEWORKSPACE_PATH,'DisplayWorkspace.txt'));
% diary on
% 
% %% Folder Names
% PAD_DIR    = 'padded/';
% AUG_DIR    = 'aug/';
% MIDDLE_DIR = 'sets/';
% TRAIN_DIR  = 'train/';
% VALID_DIR  = 'valid/';
% TEST_DIR   = 'test/';
% 
% %% Sequence of Database dir and Functions for reading database
% %  ordered by experiment
% DATABASE_DIR = { PAD_DIR , ...
%                 AUG_DIR, AUG_DIR,...
%                 AUG_DIR, AUG_DIR, ...
%                 AUG_DIR, AUG_DIR};
% 
% FcnReadExp = {  @(filename)customreader_exp1(filename),...
%                 @(filename)customreader_exp2(filename),...
%                 @(filename)customreader_exp3(filename),...
%                 @(filename)customreader_exp4(filename),...
%                 @(filename)customreader_exp5(filename),...
%                 @(filename)customreader_exp6(filename),...
%                 @(filename)customreader_exp7(filename)}; 
%             
% EXP_TITLE = {  'exp1\', ...
%                'exp2\', ...
%                'exp3\', ...
%                'exp4\', ...
%                'exp5\', ...
%                'exp6\', ...
%                'exp7\'};
%            
%  
% if(length(EXP_TITLE) ~= length(FcnReadExp) )
%     disp('Insira número igual de Funções de leitura e Diretórios de base de dados')
% end
% %%
% NumofTrainings = length(FcnReadExp);
% trainedNet = cell(NumofTrainings);

for m = 7:NumofTrainings
    
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
    
    disp(['Trainned on: ' num2str(length(trainingImages.Files)) 'images'])
    disp(['Tested on: ' num2str(length(testingImages.Files)) 'images'])

    imwrite(readimage(trainingImages,10),strcat(savedir,exp_name(1:end-1),'.png'))
    trainedNet{m} = TrainAlexNet(trainingImages,validationImages,testingImages, savedir ,exp_name);
end


    disp('----------------------------------------------------------')
    disp(['Experimento: Classificação Geral'])

%% Test ALL experiment's datasets 
confMat = cell(NumofTrainings);
% each net
for k = 1:NumofTrainings
    exp_name = EXP_TITLE{k};
    savedir = strcat(SAVEWORKSPACE_PATH,exp_name,'\');
    mkdir(savedir)
    disp('--------------------------------------------')
    disp(['NET: ' exp_name])
    disp(['Checked on every experiments testset ' DATABASE_DIR{m}])
    disp(['SAVE_DIR: ' savedir])
    confMat = zeros(36,36);
    accuracy = 0;
    % each reading form
    for m = 1:NumofTrainings
        disp('--------------------------')
        disp(['Dataset exp ID: '  EXP_TITLE{m}])
        % LOAD DATASET ONLY THE 2 FIRST EXPERIMENTS (AFTER IT'S ALL THE SAME)
        if(m<=2)
           %LOAD Database path
           DATABASE_SPEC =  DATABASE_DIR{m};       
           TEST_PATH     = [DATABASE_ROOT MIDDLE_DIR DATABASE_SPEC TEST_DIR];                         
           testingImages = imageDatastore(TEST_PATH,'LabelSource','foldernames', 'IncludeSubfolders',true);
        end    
        testingImages.ReadFcn    = FcnReadExp{m};
        
        % Classify testing Images
        tic
        predictedLabels = classify(trainedNet{k},testingImages);
        classification_time = toc;
        % conf
        
        % ACCURACY CALCULATION
        valLabels = validationImages.Labels;
        accuracy = accuracy + mean(predictedLabels == valLabels);
        % CONFUSION MATRIX
        confMat{k} = confMat{k} +confusionmat(valLabels,predictedLabels);
        %rows indicate ground truth
                
    end
    accuracy = accuracy/NumofTrainings
    C= confMat./padarray(sum(confMat,2),[0 (length(confMat)-1)],'replicate','post')
    % SAVE
    
        save(strcat(savedir,'Geral_classification_result.mat'),...
              'confMat','C','accuracy','classification_time'); % all workspace

        labels = '0123456789abcdefghijklmnopqrstuvwxyz';
        saveTable2Latex(C,labels,'confmatrixGeral.txt');
end


diary off
%%

function netTransfer = TrainAlexNet(trainingImages,validationImages,testingImages,  savedir,exp_name)
%% Load Pretrained Network

net = alexnet;
%% Transfer Layers to New Network

layersTransfer = net.Layers(1:end-3);

%%
numClasses = numel(categories(trainingImages.Labels))
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%%
%% Train Network
miniBatchSize = 10;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',true,...
    'VerboseFrequency',5000,...
    'OutputFcn',@plotTrainingAccuracy);
%% ACTUAL TRAINING
tic
netTransfer = trainNetwork(trainingImages,layers,options);
training_time = toc 

%% Classify Testing Images
tic
predictedLabels = classify(netTransfer,testingImages);
classification_time = toc 


%% ACCURACY CALCULATION
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels)
%% CONFUSION MATRIX
confMat = confusionmat(valLabels,predictedLabels)
C= confMat./padarray(sum(confMat,2),[0 (length(confMat)-1)],'replicate','post')
%rows indicate ground truth
%% SAVE
save(strcat(savedir,'workspace.mat'),...
     'valLabels','predictedLabels', 'C', 'confMat', ...
     'netTransfer','trainingImages','testingImages', ...
     'validationImages','accuracy',...
     'netTransfer','training_time','classification_time'); % all workspace
 
labels = '0123456789abcdefghijklmnopqrstuvwxyz';
saveTable2Latex(C,labels,'confmatrixIndv.txt');

MISSED_DIR = [savedir 'missedPredictions\'];
mkdir(MISSED_DIR);

% we only need to convert the directories of the missed pictures
idx = find((predictedLabels ~= valLabels));
for k = 1:length(idx)
       filename = ['Real_' char(valLabels(idx(k)))  '_Pred_' char(predictedLabels(idx(k))) '_' num2str(idx(k)) '.png'];
       writelocation =  strcat(MISSED_DIR,filename);
       im = readimage(testingImages,idx(k));
       imwrite(im,writelocation);
end
end

function netTransfer = TrainFineTuneNet(net,trainingImages,validationImages,testingImages,  savedir,exp_name)

imwrite(readimage(trainingImages,1),strcat(savedir,exp_name,'.png'))
%% Transfer Layers to New Network
layers= net.Layers;

%% Train Network
miniBatchSize = 10;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',true,...
    'VerboseFrequency',5000,...
    'OutputFcn',@plotTrainingAccuracy);
%% ACTUAL TRAINING
tic
netTransfer = trainNetwork(trainingImages,layers,options);
elapsed_time = toc 

%% Classify Validation Images
predictedLabels = classify(netTransfer,testingImages);

%% ACCURACY CALCULATION
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels)
%% CONFUSION MATRIX
confMat = confusionmat(valLabels,predictedLabels)
C= confMat./padarray(sum(confMat,2),[0 (length(confMat)-1)],'replicate','post')
%rows indicate ground truth
%% SAVE
save(strcat(savedir,'workspace.mat'),...
     'valLabels','predictedLabels', 'C', ...
     'netTransfer','trainingImages', ...
     'validationImages','accuracy',...
     'netTransfer','elapsed_time'); % all workspace
% csvwrite(strcat(savedir,'confmat.csv'),C);
end

function plotTrainingAccuracy(info)
    figure(123),
    persistent plotObj

    if info.State == "start"
        plotObj = animatedline;
        xlabel("Iteration")
        ylabel("Training Accuracy")
    elseif info.State == "iteration"
        addpoints(plotObj,info.Iteration,info.TrainingAccuracy)
        drawnow limitrate nocallbacks
    end
end
%%

function data = customreader_exp1(filename)
    data = imread(filename);
     data = data - 1;
    data = data + 1; % intention = make zeros become 1 for the updating of the network
end

function data = customreader_exp2(filename)
    data = imread(filename);
     data = data - 1;
    data = data + 1; % intention = make zeros become 1 for the updating of the network
end

function data = customreader_exp3(filename)
%% EXP 3
% pre trains using: Alexnet & the augmented folder 
% readfcn = (rgbnoise)
    
    im = imread(filename);
    %% rgbnoise
    D = imnoise(im,'gaussian',0,rand*0.01);
    %% blur
    data = imgaussfilt(D,rand*0.5);
end

function data = customreader_exp4(filename)
%% EXP 4
% pre trains using: Alexnet & the augmented folder 
% readfcn = (rgbnoise + addoffset2mask)

    im = imread(filename);
    B = uint8(zeros(size(im)));
    %% ofset2mask
    mask = segmentZeros(im);

    offset = rand*200;
    im = addOffset2Mask(im,mask,offset);    

    %% rgbnoise
    D = imnoise(im,'gaussian',0,rand*0.01);
    %% blur
    data = imgaussfilt(D,rand*0.5);
end

function data = customreader_exp5(filename)
%% EXP 5
% pre trains using: Alexnet & the augmented folder 
% readfcn = (rgbnoise + darkenhand)

    im = imread(filename);    
    %% darken
    mask = segmentZeros(im);
    im = darkenImage(im,~mask);    
    %% rgbnoise
    im = imnoise(im,'gaussian',0,rand*0.01);
    %% blur
    data = imgaussfilt(im,rand*0.5);
end

function data = customreader_exp6(filename)
%% EXP 6
% pre trains using: Alexnet & the augmented folder 
% readfcn = (rgbnoise +  bgnoise + darkenhand)
    
    im = imread(filename);     
    %% darken
    mask = segmentZeros(im);
    im = darkenImage(im,~mask);    
    %% bg noise    
    offset = rand*200;  
    B = Noise2Mask(mask,offset/255);
    im = im + im2uint8(B);
    %% rgbnoise
    im = imnoise(im,'gaussian',0,rand*0.01);
    %% blur
    data = imgaussfilt(im,rand*0.5);
end

function data = customreader_exp7(filename)
    %% EXP 7
% pre trains using:
% Alexnet
% the augmented folder and augmented  
% readfcn = at random(rgbnoise + addoffset2mask + darkenhand)
    
    im = imread(filename);   
    
    mask = segmentZeros(im);
    %% darken
    if(rand<0.5)
        im = darkenImage(im,~mask);   
    end
    %% bg noise
    if(rand<0.5)
        offset = rand*200;  
        B = Noise2Mask(mask,offset/255);
        im = im + im2uint8(B);
    end
    %% rgbnoise    
    if(rand<0.5)
        im = imnoise(im,'gaussian',0,rand*0.01);
    end
    %% blur
    data = imgaussfilt(im,rand*0.5);
end

function I = addOffset2Mask(im, mask,c)
    offset =  uint8(mask)*c;
    im(:,:,1) =  im(:,:,1) + offset;
    im(:,:,2) =  im(:,:,2) + offset;
    im(:,:,3) =  im(:,:,3) + offset;
    I = im;
end

function II = Noise2Mask(mask,offset)
    I = zeros(227,227);
    I = imnoise(I,'gaussian',offset,rand*0.1);
    II = zeros(227,227,3);
    II(:,:,1) = I;
    II(:,:,2) = I;
    II(:,:,3) = I;
    
    II = mask.*II;

end

function D = darkenImage(im,mask)
% 0.6 à 1 (40%)
% com variação de até 10% entre cores;
        r = rand(3,1)*0.1 + rand*0.3 + 0.6;
        M = zeros(size(im));
        mask = double(mask);
        M(:,:,1) = mask*r(1);
        M(:,:,2) = mask*r(2);
        M(:,:,3) = mask*r(3);
        A1 = im2double(im).*M;
        D = im2uint8(A1);
end

function I = segmentZeros(im)
    [szx,szy,~] = size(im);
    A = zeros([szx,szy]);
    A( (sum((im),3))==0)=1;
    I = bwareaopen(A,60);
end
