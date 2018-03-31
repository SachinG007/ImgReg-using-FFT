%implementation of 1996 bs reddy and chatterjee paper
%ref fig1 on the paper to better understand the code modules

I = imread('lena.bmp');
[a,b] = size(I);
J = imcrop(I);
[c,d] = size(J);
p1 = floor((a-c)/2);
p2 = floor((b-d)/2);
J = padarray(J,[p1,p2]);
J = imresize(J,[256,256]);

subplot(2,2,2)
imshow(J)
%change the rotation angle of the second image here 
prompt = 'With angle u want to distort ';
Orig_theta = input(prompt);
%Orig_theta = 37;

%create the second image
%J = imrotate(I,Orig_theta,'bicubic','loose');
J = imrotate(J,Orig_theta,'bicubic','loose');
%J = imtranslate(J,[40, 40]);

%preprocessing of the daata
I = im2double(I);
J = im2double(J);
[a,b] = size(I)
[co,do] = size(J)
J = imresize(J,a/co);
J = imtranslate(J,[50, 50]);
[c,d] = size(J);
imwrite(J,'len_rotated.png')
% subplot(2,3,1)
% imshow(I)
% subplot(2,3,2)
% imshow(J)
subplot(2,2,2)
imshow(J)
title('Image 2 , disoriented')


I(85:200,80:200) = 0;
% subplot(2,3,1)
% imshow(I)
subplot(2,2,1)
imshow(I)
imwrite(I,'lena_occluded.png')
title('Image 1, Occluded')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%data generation ends, algorithm now%%%%%%%%%
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

rec_I = imrotate(J,angle,'bicubic','loose');
% subplot(2,3,3)
% imshow(rec_I)

rec_Im = imresize(rec_I,co/a);
[g,h] = size(rec_Im);
shift1 = (g-a)/2
shift2 = (h-b)/2

if shift1==0
    shift1 = shift1+1;
    shift2 = shift2+1;
end
size(rec_Im)
shift1+a*co/a
rec_I_matched = rec_Im(shift1:shift1+a*co/a-1,shift2:shift2+b*co/a-1);
% subplot(2,3,4)
% imshow(rec_I_matched)
imwrite(rec_I_matched,'obtained.png')
[aa,bb] = size(rec_I_matched);

pad1 = ceil((aa-a)/2);
pad2 = ceil((bb-b)/2);

original_padded = padarray(I,[pad1,pad2]);
% subplot(2,3,6)
% imshow(original_padded)

% h,v= correct_translation(I,rec_I_matched);
% 
% shift_I = imtranslate(rec_I_matched,[-1*h,-1*v]);
% subplot(2,3,4)
% imshow(shift_I)

translation_interactive(original_padded)