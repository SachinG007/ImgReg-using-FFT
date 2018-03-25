I = imread('cameraman');
[a,b] = size(I);
subplot(2,2,1)
imshow(I)
J = imrotate(I,45,'bicubic','loose');
subplot(2,2,2)
imshow(J)
[c,d] = size(J)
J = imresize(J,a/c);


R = imrotate(J,-45,'bicubic','crop');
subplot(2,2,3)
imshow(R)

R2 = imrotate(J,-45,'bicubic','loose');
subplot(2,2,4)
imshow(R2)