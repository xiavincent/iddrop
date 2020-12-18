% show the combined x- and y- directional sobel edges of a grayscale image
function showDirSobel(gray_img)

    vertical_edges = edge(gray_img,'sobel','vertical');
    horizontal_edges = edge(gray_img,'sobel','horizontal');
    
    figure
    hold on
    combined = bitor(vertical_edges,horizontal_edges);
    imshow(combined)
    title('combined x- and y-directional sobel edges');
    
    bndry = traceExposedDome(combined); % trace the dome and return the indices of the pixel boundaries
    
    for i=1:length(bndry)
        combined(bndry(i,1),bndry(i,2)) = 0; % remove the boundary of the dome from the image
    end    
    
    figure
    imshow(combined)
    
    % NOTE: doesn't work because directional sobel can't adequately detect film edges
         
end