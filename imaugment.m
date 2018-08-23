function I = imaugment(im, N)
% Outputs sequence of N images. Size (227,227,3,N)
% Input:
% im - Image that should be augmented:
%        - rotations      [-30    30 ] 
%        - stretching x   [0.9    1.1]
%        - stretching y   [0.9    1.1] 
%        - scaling        [0.35  0.85] 
%                         hand fill at most 85% pixels of the pictures (192 pixels)
%                         and at least 35% pixels of the pictures ( 80 pixels)
%        - translating    [0 1]  
%                         Image can be anywhere in the image
%                         The hand will never be cropped
%                                
I = uint8(zeros(227,227,3,N));

I_hf = flipdim(im ,2);


stretch = rand(N,4)*0.2 + 0.9;

% Copy image N times, same quantity of original x mirrors
% force image to have 227 pixels and stretches
for i = 1:2:(N-1)
    I(:,:,:,i+0) = imsquare(im,   227, stretch(i,1:2));
    I(:,:,:,i+1) = imsquare(I_hf, 227, stretch(i,3:4));    
end


% Angle variations goes from -30 to 30, we will separate negative angles
% from positive angles to make sure we have the same amount of samples for
% each quadrant
angle_p = 30*rand(N,2);
angle_n = -30*rand(N,2);
    
% There will be a positive and a negative angled sample for the original and
% for the mirrored image
for i = 3:4:(N-3)
    I(:,:,:,i+0) = imsquare(imrotate(I(:,:,:,i+0), angle_p(i,1)), 227, 1);
    I(:,:,:,i+1) = imsquare(imrotate(I(:,:,:,i+1), angle_p(i,2)), 227, 1);
    I(:,:,:,i+2) = imsquare(imrotate(I(:,:,:,i+2), angle_n(i,1)), 227, 1);
    I(:,:,:,i+3) = imsquare(imrotate(I(:,:,:,i+3), angle_n(i,2)), 227, 1);    
end

% scale and pad all of the above
where = round(rand(N,2));
scaleRatio = rand(N,1)*0.5+0.35;
for i = 1:N
     I(:,:,:,i) = imreduce(I(:,:,:,i),where(i,1),where(i,2),scaleRatio(i));
end


%% plot
% figure,
% for i = 1:N
%     subplot(6,ceil(N/6),i), imshow(I(:,:,:,i))
% end

end