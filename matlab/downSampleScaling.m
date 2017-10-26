function scaleSpace = downSampleScaling(I, k, scaleSpace, log)
% Arguments:   
%            I          - image to be processed.
%            k          - scale multiplication factor.
%            scaleSpace - result of filtered layers.
%            log        - Laplacian of Gaussian filter.
%
% Returns:
%            scaleSpace - result of filtered layers.

tic
n = size(scaleSpace, 3);
curImg = I;
for i=1:n
    curImg = imresize(I, 1/(k^(i-1)), 'bicubic');
    filteredImg = imfilter(curImg, log, 'same', 'replicate');
    filteredImg = filteredImg .^ 2;
    scaleSpace(:,:,i) = imresize(filteredImg, size(I), 'bicubic');
end
toc