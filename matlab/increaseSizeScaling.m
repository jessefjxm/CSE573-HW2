function scaleSpace = increaseSizeScaling(I, k, scaleSpace, sigma)
% Arguments:   
%            I          - image to be processed.
%            k          - scale multiplication factor.
%            scaleSpace - result of filtered layers.
%            sigma      - initial scale factor.
%
% Returns:
%            scaleSpace - result of filtered layers.

tic
n = size(scaleSpace, 3);
for i=1:n
    curSigma = sigma*k^(i-1);
    filterSize = ceil(3*curSigma)*2+1;
    log = fspecial('log', filterSize, curSigma)*curSigma^2;
    filteredImg = imfilter(I, log, 'same', 'replicate');
    filteredImg = filteredImg .^ 2;
    scaleSpace(:,:,i) = filteredImg;
end
toc