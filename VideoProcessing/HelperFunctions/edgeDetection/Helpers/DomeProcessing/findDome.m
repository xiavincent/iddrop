% Find the exposed dome from an RGB image and return a mask of it
function dome_mask = findDome(RGB_img)
    grayscale_img = rgb2gray(RGB_img);
    edges = getEdges(grayscale_img); % get the binary edges
    edges = closeEdges(edges); % close the edges to fill in gaps
    dome = imfill(edges,'holes');
    
    area_range = [100000 300000]; % acceptable dome size between 100k and 300k pixels
    dome_mask = bwareafilt(dome,area_range);
    
    if (nnz(dome_mask) == 0) % if no acceptable dome was found, throw an error
        error('Error: No dome outline could be detected! Check input video quality.');
    end
end