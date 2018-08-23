% read dataset and save padded version in dimensions 227x227
INPUTSIZE=227;
HANDSIZE=100;
filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset';
images = imageDatastore(filepath, 'LabelSource','foldernames');
 L = length(images.Files);
  for i=1:L
      filename = images.Files{i}(70:end);
      im = readimage(images,i);
      [ma,dima] = max(size(im(:,:,1)));
      [mi,dimi] = min(size(im(:,:,1)));
      im = imresize(im,HANDSIZE/ma);
      pd = zeros(1,2);
      pd(dimi) = floor((HANDSIZE - mi*(HANDSIZE/ma))/2);
      pd(dima) = 0;
      im = padarray(im,pd,0,'both');
      im = imresize(im,[HANDSIZE HANDSIZE]);
      im = padarray(im,[(INPUTSIZE-HANDSIZE-1)/2 (INPUTSIZE-HANDSIZE-1)/2],0);      
      
      im = imresize(im,[INPUTSIZE INPUTSIZE]);
      imwrite(im,strcat(filepath, '/padded/', filename));
  end
  