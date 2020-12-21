% return a mask of the film area using the Sobel gradient magnitude of a grayscale image
% INPUT: sobel gradient magnitude image
function filled = findFilmArea(gray_img,dome_mask)
    figure
    [Gmag,Gdir] = imgradient(gray_img);
    imshowpair(Gmag,Gdir,'montage')
    title('Gradient Magnitude (Left) and Gradient Direction (Right)')
 
    filled = floodFill(Gmag,dome_mask); % flood fill film area using gradient magnitudes and export result
end

function filled = floodFill(gradient_magnitude,dome_mask) % flood fill wetted portion of gradient image

    mag_img = mat2gray(gradient_magnitude); % convert to grayscale
    
    f = figure;
    ax = axes(f);
    imshow(mag_img,'Parent',ax);
    title(ax,'grayscale gradient magnitude image');
   
    figure
    binary = imbinarize(mag_img,'adaptive');
    
    clean_size = 200;
    binary_clean = bwareaopen(binary,clean_size); % remove small objects
    binary_clean(~dome_mask) = 0; % clear everything outside of the exposed dome
    
    % TODO: apply area mask instead of applying dome mask... that way you can easily get rid of
    % the dome from the skeleton, and then simply apply 'imfill'
    
    
    % TODO: close the edges if not already closed
%     closed = closeEdges(binary_clean);

    skel = removeDomeEdges(binary_clean); % remove the dome edges, if they exist, and return the skeletonized binary image
    
    filled = imfill(skel,'holes'); % flood fill the film area
    imshow(filled)
    
    %%
    % Notes: Works moderately well; expect some variation in film area inclusion based on edge
    % detection
    % TODO: test on different frames

end
