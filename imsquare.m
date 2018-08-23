function Im = imsquare(A, SIZE, stretch )
% Im = imsquare(A, SIZE, stretch )
% A - img
% SIZE - size of the square
% stretch - 1.0 stands for no strech

% normalize size of the image (the hand should have 227 pixels (vertical or horizontal)
       [ma,dima] = max(size(A(:,:,1)));
       [mi,dimi] = min(size(A(:,:,1)));
       A = imresize(A,SIZE/ma);
       
% Stretch and re-normalize size of the hand to 227 pixels
       A = imresize( A, round(size(A(:,:,3)).*stretch) );
       
       [ma,dima] = max(size(A(:,:,1)));
       [mi,dimi] = min(size(A(:,:,1)));       
       A = imresize(A,SIZE/ma);
       
% Pad the narrow side of the hand to 227 pixels
       pd = zeros(1,2);
       pd(dimi) = round((SIZE - mi*(SIZE/ma))/2);
       pd(dima) = 0;
       A = padarray(A,pd,0,'both');
       
% Adjust for the exact dimensions
       Im = imresize(A,[SIZE SIZE]);
end