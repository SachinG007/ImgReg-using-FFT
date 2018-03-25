function [trans_horizontal,trans_vertical] = correct_translation(I,J)

%preprocessing of the daata
I = im2double(I);
J = im2double(J);
[a,b] = size(I)
[c,d] = size(J);
% subplot(2,2,1)
% imshow(I)
% subplot(2,2,2)
% imshow(J)

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