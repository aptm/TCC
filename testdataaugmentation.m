
filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';
folder = 'original/';
savepath = [filepath 'test_augmentation/'];
mkdir(savepath);
filename = 'hand1_d_bot_seg_2_cropped.png';
im = imread([filepath folder filename]);

filename = extractBefore(filename,'.png');

%% augmentation
N=38;
I = imaugment(im,N);

%% Save
for i = 1:N
   num = num2str(i,'%.3d');
   imwrite(I(:,:,:,i),strcat([savepath filename],'_', num, '_aug.png'));
end

