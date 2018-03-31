%implementation of 1996 bs reddy and chatterjee paper
%ref fig1 on the paper to better understand the code modules
function [trans_horizontal,trans_vertical] = translation(I)

%create the second image (translation)
J = imread('obtained.png');


%preprocessing of the daata
I = im2double(I);
%I(50:100,80:130) = 255;
J = im2double(J);
[a,b] = size(I);
[c,d] = size(J)

if a-c == 1
    J = padarray(J,[1,1],0,'post');
end

%retrieve the translation params using phase correlation
% subplot(2,2,1)
% imshow(I)
% subplot(2,2,2)
% imshow(J)
phase1 = fft2(I);
phase2 = fft2(J);

r0 = abs(phase2 .* phase1);
ir = abs(ifft2(phase2 .* conj(phase1) ./ r0));

[M,idx] = max(ir(:));
[I_row, I_col] = ind2sub(size(ir),idx);
trans_horizontal = I_col - 1
trans_vertical = I_row - 1
[xdim,ydim] = size(ir);

sj = size(J)
if trans_horizontal>120
    trans_horizontal = 256-trans_horizontal;
    shift_I = imtranslate(J,[trans_horizontal,-1*trans_vertical]);
else
    shift_I = imtranslate(J,[-1*trans_horizontal,-1*trans_vertical]);
end

% subplot(2,3,5)
% imshow(shift_I)
subplot(2,2,3)
imshow(shift_I)
title('result 1, Image oriented using FFT')

if size(shift_I) == size(I)
    'true'
end

count =0

for l=10:size(I,1)-10
    for m=10:size(I,2)-10
        if I(l,m)<.05
            
            I(l,m) = shift_I(l,m);
            count = count+1;
        end
    end
end

count
% subplot(2,3,4)
% imshow(I)
subplot(2,2,4)
imshow(I)
title('result 2, information gained from image2')



