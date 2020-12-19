% show the combined x- and y- directional sobel edges of a grayscale image
function showDirSobel(gray_img)

%     vertical_edges = edge(gray_img,'sobel','vertical');
%     horizontal_edges = edge(gray_img,'sobel','horizontal');
%     combined = bitor(vertical_edges,horizontal_edges);

    [Gx, Gy] = imgradientxy(gray_img); % find the x and y directional sobel gradients
    combined = sqrt(Gx.^2 + Gy.^2); % use the sobel edge detection algorithm used by imageJ
    intensity = mat2gray(combined);
%     clean_size = 200;
%     combined = bwareaopen(combined,clean_size);
    
    figure
    hold on
    imshow(mat2gray(combined))
    title('combined x- and y-directional sobel edges after cleaning');
    
    disk_rad = 5;
    closed = closeEdges(combined); % use morphological mask closing to correctly enclose the dome
    skel = removeDomeEdges(closed); % remove the dome edges
    
    figure
    imshow(skel)
    
    % NOTE: doesn't work because directional sobel can't adequately detect film edges
         
end