% show the combined x- and y- directional sobel edges of a grayscale image
function showDirSobel(gray_img)

    vertical_edges = edge(gray_img,'sobel','vertical');
    horizontal_edges = edge(gray_img,'sobel','horizontal');
    
    figure
    hold on
    combined = bitor(vertical_edges,horizontal_edges);
    
    clean_size = 200;
    combined = bwareaopen(combined,clean_size);
    imshow(combined)
    title('combined x- and y-directional sobel edges after cleaning');
    
    disk_rad = 5;
    closed = closeEdges(combined,disk_rad); % use morphological mask closing to correctly enclose the dome
    skel = removeDomeEdges(closed); % remove the dome edges
    
    figure
    imshow(skel)
    
    % NOTE: doesn't work because directional sobel can't adequately detect film edges
         
end