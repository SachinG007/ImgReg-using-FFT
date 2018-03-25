%implementation of 1996 bs reddy and chatterjee paper
%ref fig1 on the paper to better understand the code modules
function [trans_horizontal,trans_vertical] = translation(I)

%create the second image (translation)
J = imtranslate(I,[55, 75]);
J = imread('obtained.png')


%preprocessing of the daata
I = im2double(I);
J = im2double(J);
[a,b] = size(I)
[c,d] = size(J);
imwrite(J,'cam_translated.png')
% figure
% subplot(2,2,1)
% imshow(I)
% subplot(2,2,2)
% imshow(J)

%JJ = imtranslate(J,[-25.3, -10.1],'FillValues',0,'OutputView','same');
%subplot(2,2,3)
%imshow(JJ)
%%
%retrieve the translation params using phase correlation
phase1 = fft2(I);
phase2 = fft2(J);

r0 = abs(phase2 .* phase1);
ir = abs(ifft2(phase2 .* conj(phase1) ./ r0));

[M,idx] = max(ir(:));
[I_row, I_col] = ind2sub(size(ir),idx);
trans_horizontal = I_col - 1
trans_vertical = I_row - 1
[xdim,ydim] = size(ir);

if trans_horizontal>120
    trans_horizontal = 256-trans_horizontal
    shift_I = imtranslate(J,[trans_horizontal,-1*trans_vertical]);
else
    shift_I = imtranslate(J,[-1*trans_horizontal,-1*trans_vertical]);
end

subplot(2,3,5)
imshow(shift_I)


