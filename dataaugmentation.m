DATABASE_ROOT = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';

ORIGINALDB_PATH = [DATABASE_ROOT 'original/'];
images = imageDatastore(ORIGINALDB_PATH, 'LabelSource','foldernames')

le = length(ORIGINALDB_PATH);

%% augment t by 5 pictures
% t_index = {726:750 ;1626:1645 ;1941:1945; 2121:2125 ;2446:2455}
% 
% color_change = round(rand(5,1)*5);  % darken up to 5 intensity values
% stretch      = rand(5,2)*0.2 + 0.9; % stretch +- 0.1%
% angle        = rand(5,1)*10  - 5    % rotate +- 5°
% for k = 1:5
%     sample = datasample(t_index{k},1,'Replace',false)
%     A  = readimage(images,sample);
%     SIZE = size(A(:,:,3))
% % Stretch and re-normalize size of the hand to 227 pixels
% 
%     
%     A = imresize( A, round(SIZE.*stretch(k)) );
%     
%     A = imrotate(A, angle(k,1));
%     A = A - color_change(k);
%     
%     filename = images.Files{sample}(le+1:end-4);
%     imwrite(A,strcat(filepath,filename,'_', num, '_aug.png'));
% end

L = length(images.Files);

filepath2write_train = [DATABASE_ROOT 'aug/'];
filepath2write_test = [DATABASE_ROOT 'testset/'];
mkdir(filepath2write_train);
mkdir(filepath2write_test);

for k = 1:L
    
    filename = images.Files{k}(le+1:end-4);
    im = readimage(images,k);
    %% TRAINING SET + VALIDATION SET
    N_train=40;
    filepath_train = strcat(filepath2write_train,filename);
    
    I_train = imaugment(im,N_train);
    
    %% TESTSET   
    N_test=26;
    filepath_test = strcat(filepath2write_test,filename);

    I_test = imaugment(im,N_test);

%% check if no test image is the same as training image
for m = 1:N_test
    for n = 1:N_train
        if(isequal(I_test(:,:,:,m),I_train(:,:,:,n)))
            color_change = round(rand(1,1)*4 + 1);  % darken up to 5 intensity values
            stretch      = rand(1,2)*0.2 + 0.9; % stretch +- 0.1%
            I_test(:,:,:,m) = imsquare(I_test(:,:,:,m),227, stretch) - color_change; 
            disp(['this img was the same:' filename 'at test/aug_' num2str(m) ' and at train/aug_' num2str(m) ] );
        end
    end
end

    
    
    
    %% Save train
    for i = 1:N_train

       num = num2str(i,'%.3d');
       imwrite(I_train(:,:,:,i),strcat(filepath_train,'_', num, '_aug.png'));
    end
    
    %% Save test
    for i = 1:N_test

       num = num2str(i,'%.3d');
       imwrite(I_test(:,:,:,i),strcat(filepath_test,'_', num, '_aug.png'));
    end
end


%%


filepath2write_train = [DATABASE_ROOT 'aug/'];
mkdir(filepath2write_train);
mkdir(filepath2write_test);

for k = 1:L
    
    filename = images.Files{k}(le+1:end-4);
    im = readimage(images,k);
    %% TRAINING SET + VALIDATION SET
    N_train=40;
    filepath_train = strcat(filepath2write_train,filename);
    
    I_train = imaugment(im,N_train);
    
    %% Save train
    for i = 1:N_train

       num = num2str(i,'%.3d');
       imwrite(I_train(:,:,:,i),strcat(filepath_train,'_', num, '_aug.png'));
    end
  
end
