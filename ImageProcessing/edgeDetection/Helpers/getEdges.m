%% FUNCTION
% Get sobel edges using the imageJ
% edge detection algorithm
%------------------------------
% Input: Grayscale image
% Output: binary mask of edges
%------------------------------

function binary_edges = getEdges(gray_img)
    [Gx, Gy] = imgradientxy(gray_img); % find the x and y directional sobel gradients
    combined = sqrt(Gx.^2 + Gy.^2); % use the sobel edge detection algorithm used by imageJ
    intensity = mat2gray(combined);
    
    figure
    hold on
    imshow(intensity);
    title('combined x- and y-directional sobel edges after edge detection algorithm');
    
    binary_edges = imbinarize(intensity); % binarize the intensity image
%     clean_size = 50;
%     binary_edges = bwareaopen(binary_edges,clean_size); % remove small objects from image
    
    figure
    imshow(binary_edges)
    title('binarized edges');       
end