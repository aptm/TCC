% 'E:/UFCG/ExperimentosAna/database/MasseyUniversity HandImages ASL Dataset/aug2'
filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/padded/'
imds = imageDatastore(filepath,'ReadFcn',@customreader);

L = length(imds.Files);

for k = 1:6
  %  filename = images.Files{k}(length(filepath)+1:end);
    im = readimage(imds,k);
    figure, imshow(im);
end


function data = customreader(filename)
    im = imread(filename);
    B = uint8(zeros(size(im)));
    %% Segment
    mask = segmentZeros(im);

    %% Darken hand
    if(rand <0.5)
        im = darkenImage(im, ~mask);
    end
    %% noise background
    if(rand < 0.5)
        B = Noise2Mask(mask,125/255);
        B = im2uint8(B);
    else
        offset = rand*200;
        im = addOffset2Mask(im,mask,offset);    
    end
    
    %% noise
    C = im + B;
    D = imnoise(C,'gaussian',0,rand*0.01);
    %% blur
    data = imgaussfilt(D,rand*0.5);
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
        r = rand(3,1)*0.1 + rand*0.3 + 0.6;
        M = zeros(size(im));
        mask = double(mask);
        M(:,:,1) = mask*r(1);
        M(:,:,2) = mask*r(2);
        M(:,:,3) = mask*r(3);
        A1 = im2double(im).*M;
        A1(A1<0)=0;
        D = im2uint8(A1);
end

function I = segmentZeros(im)
    [szx,szy,~] = size(im);
    A = zeros([szx,szy]);
    A( (sum((im),3))==0)=1;
    I = bwareaopen(A,60);
end
