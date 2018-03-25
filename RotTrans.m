%implementation of 1996 bs reddy and chatterjee paper
%ref fig1 on the paper to better understand the code modules

I = imread('cameraman');
%change the rotation angle of the second image here 
Orig_theta = 63.5
%create the second image
J = imrotate(I,Orig_theta,'bilinear','loose');
J = imtranslate(J,[55, 55]);

%preprocessing of the daata
I = im2double(I);
J = im2double(J);
[a,b] = size(I)
[co,do] = size(J)
J = imresize(J,a/co);
[c,d] = size(J)
imwrite(J,'cam_rotated.png')
subplot(2,2,1)
imshow(I)
subplot(2,2,2)
imshow(J)

%%
%fftmodule
fftI = (fft2(I));
fftJ = (fft2(J));
%done to zero mean the fft, a good pratice in img processing community
fftI = fftshift(fftI);
fftJ = fftshift(fftJ);


%highpass module %used someone elses function for this, same as given in
%the paper
highI = hipass_filter(a,b).*abs(fftI);  
highJ = hipass_filter(c,d).*abs(fftJ);

%logpolar resample module, % used someone elses code for log polar
%transform
logPolarI = transformImage(highI, a, b, a, b, 'nearest', size(highI) / 2, 'valid');
logPolarJ = transformImage(highJ, a, b, a, b, 'nearest', size(highJ) / 2, 'valid');

%retrieve the rotation angle using the phase correlation
% computing theta using phase correlation
phase1 = fft2(logPolarI);
phase2 = fft2(logPolarJ);

r0 = abs(phase2 .* phase1);
ir = abs(ifft2(phase2 .* conj(phase1) ./ r0));

[M,idx] = max(ir(:));
[I_row, I_col] = ind2sub(size(ir),idx);
[xdim,ydim] = size(ir);
angle = 360 * (I_col-1)/ydim

rec_I = imrotate(J,angle);
subplot(2,2,3)
imshow(rec_I)

Isub = I(1:200,1:200);
rec_Isub = rec_I(1:200,1:200);
trans_horizontal,trans_vertical = correct_translation(Isub,rec_Isub);

Orig_theta


