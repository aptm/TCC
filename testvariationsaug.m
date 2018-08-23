
filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/';
folder = 'test_augmentation/';
imdspath = [filepath folder];
savepath = [filepath 'test_bgnoise/'];
mkdir(savepath);

images = imageDatastore(imdspath, 'LabelSource','foldernames', 'IncludeSubfolders',true)

L = length(images.Files);
%%
for k = 1:L
    filename = images.Files{k}(length(imdspath)+1:end);
    im = readimage(images,k);
    %% background segmentation
    mask = segmentZeros(im);
    % 
    % figure,
    % imshow(A);

    %% Darken hand

    if(rand <0.5)
        im = darkenImage(im);
    end

    % figure,
    % imshow((im));
    %% noise
    B = Noise2Mask(mask);
    % 
    % figure,
    % imshow(B);
    %%
    C = im + uint8(B*255);
    C = imgaussfilt(imnoise(C,'gaussian',0,rand*0.01),rand*0.5);
%     figure,
%     imshow((C));

    %% Save

     imwrite(C,strcat([savepath filename]));


end




function II = Noise2Mask(mask)
    I = ones(227,227)*0.5;
    I = imnoise(I,'gaussian',0,rand*0.1);
    II = zeros(227,227,3);
    II(:,:,1) = I;
    II(:,:,2) = I;
    II(:,:,3) = I;
    
    II = mask.*II;

end

function D = darkenImage(im)
        A1 = uint8(ones(size(im)));
        r = rand(3,1)*0.2 + 0.6;
        A1(:,:,1) = im(:,:,1)*r(1);
        A1(:,:,2) = im(:,:,2)*r(2);
        A1(:,:,3) = im(:,:,3)*r(3);
        A1(A1<0)=0;
        D = A1;
end

function B = segmentZeros(im)
    [szx,szy,~] = size(im);
    A = zeros([szx,szy]);
    A( (sum((im),3))==0)=1;
    B = bwareaopen(A,60);
end