function Im = imreduce(A, Ypos, Xpos, ratio)
% Im = imreduce(A, Ypos, Xpos, ratio)
% this function performs imresize + impad  
% - A             Image
% - Ypos, Xpos    Indicate the location of the new image (in percentage 0-1)
%                 where the reduced image is pasted
%                 but does not let the image be out of bounds
% - ratio         Indicate the proportion of the reduction (in percentage 0-1)

%%%%%%%%%%%%%% TEST
% % % % % A = imsquare(imread('dummy/b/d.png'),227,1);
% % % % % Ypos = 0.777777777777777777777;
% % % % % Xpos = 0.321321231312122121212;
% % % % % ratio = 0.5;

[sY,sX,~] = size(A);
A = imresize(A, ratio);

% does not let the image be out of bounds
[nY,nX,~] = size(A);
Ypos = round((sY-nY)*Ypos); 
Xpos = round((sX-nX)*Xpos); 

pad_pre = [Ypos Xpos];
pad_pos = [sY-nY sX-nX] - pad_pre;
A = padarray(A,pad_pre,0,'pre');
Im = padarray(A,pad_pos,0,'pos');

end