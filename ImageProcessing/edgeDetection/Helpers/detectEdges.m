% Detect the edges of a thin film
function detectEdges()
    %% add folders to path and pull frame of interest
    addPath();
    
    %%
    RGB = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame10225.tif');
    HSV = rgb2hsv(RGB);
    gray = rgb2gray(RGB);
    
    %% Get a mask of the dome
    
%     dome_mask = findDome(RGB); % NOTE: only run 'findDome' on the frame for area selection
    
    %% Get black parts of image (for characterization of ultra-thin films)
%     getBlackPix(RGB);
      
    %% visualize edges
%     close all
%     sobel_step_size = 0;
%     sobel_sens = .0164 + sobel_step_size; % sobel sensitivity
%     
%     step_high = 0.19;
%     can_sens = .0781 + step_high;   % alternative format:can_sens = [0.0312+step_low , 0.0781+step_high];
%     
%     showEdges(gray,sobel_sens,can_sens); % visualize the edges in a figure using given senstivities as settings
    
    %% segment film area from gradient magnitude  
    wet_film = findFilmArea(gray,dome_mask);
    
    overlay = imoverlay(RGB,wet_film,'red'); % burn binary mask into original image
    figure
    imshow(overlay) % display result
    
    %% Single direction sobel detection
%     showDirSobel(gray);

end

%% Private helper functions

function addPath() % add subfolders to the path
    folder = fileparts(which(mfilename)); % currently running folder
    addpath(genpath(folder)); % Add the folder plus all subfolders to the path.
end

% return a mask of the film area using the Sobel gradient magnitude of a grayscale image
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



