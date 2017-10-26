function blobDetection(imgname)
% load image
img = imread(strcat('../data/',imgname));
I = im2double(rgb2gray(img));

% prepare parameters
sigma = 2;              % sigma & initial scale
k = 1.1;            % scale multiplication factor
n = 20;                 % total scale layers
[h, w] = size(I);
scaleSpace = zeros(h, w, n);

% 1. Generate a Laplacian of Gaussian filter.
filterSize = [15 15];   % filter size of LoG
log = fspecial('log', filterSize, sigma)*sigma^2;

% 2. Build a Laplacian scale space, starting with some initial scale and going for n iterations:
%(a) Filter image with scale-normalized Laplacian at current scale.
%(b) Save square of Laplacian response for current level of scale space.
%(c) Increase scale by a factor k.

scaleSpace = downSampleScaling(I, k, scaleSpace, log);
%scaleSpace = increaseSizeScaling(I, k, scaleSpace, sigma);

% 3. Perform nonmaximum suppression in scale space.
[cx, cy, rad] = nonmaximumSuppression(k, scaleSpace, sigma);

% 4. Display resulting circles at their characteristic scales.
show_all_circles(I, cx, cy, rad);

% save the result
imwrite(frame2im(getframe(gca)),strcat('../data/result_',imgname));