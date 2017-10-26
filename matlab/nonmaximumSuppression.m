function [cx, cy, rad] = nonmaximumSuppression(k, scaleSpace, sigma)
% Arguments:   
%            k          - scale multiplication factor.
%            scaleSpace - result of filtered layers.
%            sigma      - initial scale factor.
%
% Returns:
%            cx, cy  - column vectors with x and y coordinates of circle centers
%            rad     - column vector with radii of circles. 

% parameters
cy = [];cx = [];rad = [];
h = size(scaleSpace, 1);
w = size(scaleSpace, 2);
n = size(scaleSpace, 3);

suppRadius = 1;                 % radius that combine adjecent results
suppSize = 2*suppRadius+1;
threshold = 0.01;               % threshold that filter out inconspicious results
maxSpace = zeros(h, w, n);

% Perform nonmaximum suppression in each scale
for i=1:n
    maxSpace(:,:,i) = ordfilt2(scaleSpace(:,:,i), suppSize^2, ones(suppSize));
end

% combine results of all scales
for i=1:n
    maxSpace(:,:,i) = max(maxSpace,[],3);
end
maxSpace = maxSpace .* (maxSpace == scaleSpace) .* (maxSpace >= threshold);

% get coordinates of blobs
for i=1:n
    [rows, cols] = find(maxSpace(:,:,i));
    if(length(rows) >0)
        r = repmat(sigma*k^(i-1)*sqrt(2), length(rows), 1);
        cx = [cx; cols];
        cy = [cy; rows];
        rad = [rad; r];
    end
end
