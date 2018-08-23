filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/original/';
images = imageDatastore(filepath, 'LabelSource','foldernames');
write2location = 'D:\Documents\TCC\cola_asl\';

  L = length(images.Files);
  UserID = zeros(1,L);
  le = length(filepath);
  for i=1:L
      filename = images.Files{i}(le+1:end);
      UserID(i) = filename(5);
      images.Labels(i)= filename(7);
  end
  


LabelCount = countEachLabel(images)
LabList = LabelCount(:,1);
L = height(LabelCount); %36
prelabel = categorical(nan);
label = images.Labels(1);
figure
k=1;
i=1;


idx = zeros(1,L);
while(i<=36)
    label = images.Labels(k);
    if(label ~= prelabel)
        idx(i) = k;        
        prelabel = label;
        i=i+1;
    end
    k=k+1;
end

%% Ajusta tamanho da mao na img
INPUTSIZE=227;
HANDSIZE=200;

nRows = 6 ;
nCols = 6 ;
 % - Create figure, set position/size to almost full screen.
 figure() ;
 set( gcf, 'Units', 'normalized', 'Position', [0.1,0.1,0.8,0.8] ) ;
 % - Create grid of axes.
 spacing = 0.9;
 [blx, bly] = meshgrid( 0.8:-0.9/nCols:0.05, 0.05:0.9/nRows:0.9 ) ;
 hAxes = arrayfun( @(y,x) axes( 'Position', [x, y, 0.9*spacing/nCols, 0.9*spacing/nRows] ), blx, bly, 'UniformOutput', false ) ;
 
 

for i=1:L
      im = readimage(images,idx(i));
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
      imwrite(im, [write2location char(images.Labels(idx(i))) '.png'])
      
    axes( hAxes{i} ) ;
    text_str = upper(char(images.Labels(idx(i))));
    im = insertText(im ,[160 150],text_str,'FontSize',50,'BoxColor',...
    'black','TextColor','white');
    image( im ) ;
    set( gca, 'Visible', 'off','DataAspectRatio', [1 1 1] ) ;
%         axes(hA(i));
%         image(im)
        title(upper(char(images.Labels(idx(i)))))
end
  
 %% Show each variation
 filepath = 'C:/Users/Ana Paula/Downloads/MasseyUniversity HandImages ASL Dataset/original/';

nRows = 5 ;
nCols = 3 ;

dataarray = {'hand1_0_bot_seg_1_cropped.png',...
    'hand1_0_right_seg_1_cropped.png',...
    'hand1_0_dif_seg_1_cropped.png',...
    'hand1_0_top_seg_1_cropped.png',...
    'hand1_0_left_seg_1_cropped.png',...
    'hand2_0_bot_seg_1_cropped.png',...
    'hand2_0_left_seg_1_cropped.png',...
    'hand2_0_right_seg_1_cropped.png',...
    'hand2_0_top_seg_5_cropped.png', ...
    'hand2_0_dif_seg_1_cropped.png',...
    'hand3_0_dif_seg_1_cropped.png',...
    'hand3_0_dif_seg_2_cropped.png',...
    'hand4_0_bot_seg_2_cropped.png',...
    'hand5_0_bot_seg_1_cropped.png',...
    'hand5_0_dif_seg_1_cropped.png',...
    };
    
 % - Create figure, set position/size to almost full screen.
 figure() ;
 set( gcf, 'Units', 'normalized', 'Position', [0.1,0.1,0.7,0.7] ) ;
 % - Create grid of axes.
 spacing = 0.9;
 [blx, bly] = meshgrid( 0.8:-0.6/nCols:0.3, 0.05:0.9/nRows:0.9 ) ;
 hAxes = arrayfun( @(y,x) axes( 'Position', [x, y, 0.9*spacing/nCols, 0.9*spacing/nRows] ), blx, bly, 'UniformOutput', false ) ;
 
for i=1:length(dataarray)
      im = imread([filepath dataarray{i}]);
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
      imwrite(im, [write2location char(images.Labels(idx(i))) '.png'])
      
    axes( hAxes{i} ) ;
    text_str = upper(char(dataarray{i}(5)));
    im = insertText(im ,[160 150],text_str,'FontSize',50,'BoxColor',...
    'black','TextColor','white');
    image( im ) ;
    set( gca, 'Visible', 'off','DataAspectRatio', [1 1 1] ) ;
%         axes(hA(i));
%         image(im)
        title(upper(char(images.Labels(idx(i)))))
end
  
  
 
 