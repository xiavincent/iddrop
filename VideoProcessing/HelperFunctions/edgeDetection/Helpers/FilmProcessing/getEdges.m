%% FUNCTION
% Get sobel edges of grayscale image using the imageJ
% edge detection algorithm
%------------------------------
% Input: Grayscale image
% Output: binary mask of edges
%------------------------------

function binary_edges = getEdges(gray_img)
    [Gx, Gy] = imgradientxy(gray_img); % find the x and y directional sobel gradients
    combined = sqrt(Gx.^2 + Gy.^2); % use the sobel edge detection algorithm used by imageJ
    intensity = mat2gray(combined);
    binary_edges = imbinarize(intensity); % binarize the intensity image
end