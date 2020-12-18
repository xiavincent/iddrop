% Detect the edges of a thin film
function detectEdges()
    
    RGB = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame597.tif');
    HSV = rgb2hsv(RGB);
    gray = rgb2gray(RGB);
    
    %% Get black parts of of image
    getBlackPix(RGB);
      
    %% visualize edges
    close all
    sobel_step_size = 0;
    sobel_sens = .0164 + sobel_step_size; % sobel sensitivity
    
    step_high = 0.19;
    can_sens = .0781 + step_high;   % alternative format:can_sens = [0.0312+step_low , 0.0781+step_high];
    
    showEdges(gray,sobel_sens,can_sens); % visualize the edges in a figure using given senstivities as settings
    
    %% gradient visualization    
    filled_wet_area = fillGradientMag(gray);
    overlay = imoverlay(RGB,filled_wet_area,'red'); % burn binary mask into original image
    figure
    imshow(overlay) % display result
    
    %% Single direction sobel detection
    showDirSobel(gray);

end

%% Helper functions


% return a mask of the film area using the Sobel gradient magnitude of a grayscale image
function filled = fillGradientMag(gray_img)
    figure
    [Gx,Gy] = imgradientxy(gray_img);
    imshowpair(Gx,Gy,'montage')
    title('Directional Gradients Gx and Gy, Using Sobel Method')
    
    figure
    [Gmag,Gdir] = imgradient(Gx,Gy);
    imshowpair(Gmag,Gdir,'montage')
    title('Gradient Magnitude (Left) and Gradient Direction (Right)')
    
    filled = floodFill(Gmag); % flood fill gradient magnitude image and export result
end

function filled = floodFill(gradient_magnitude) % flood fill wetted portion of gradient image

    mag_img = mat2gray(gradient_magnitude); % convert to grayscale
    
    f = figure;
    ax = axes(f);
    imshow(mag_img,'Parent',ax);
    title(ax,'grayscale gradient magnitude image');
   
    figure
    binary = imbinarize(mag_img);
    imshow(binary)
    
    disk_rad = 5;
    closed = closeEdges(binary,disk_rad); % use morphological mask closing to correctly enclose the dome
    skel = removeDomeEdges(closed); % remove the dome edges and return the skeletonized binary image
    
    filled = imfill(skel,'holes'); % flood fill the film area
    imshow(filled)
    
    % Works moderately well; expect some variation in film area inclusion based on edge
    % detection
    % TODO: test on different frames

end

function skel = removeDomeEdges(binary) % skeletonize a binary image and remove the edges, returning the result
    skel = bwskel(binary); % get the skeleton mask of the image
    bndry = traceExposedDome(skel);
    
    for i=1:length(bndry)
        skel(bndry(i,1),bndry(i,2)) = 0; % remove the boundary of the dome from the image
    end
end

% use a disk shape to morphologically close the edges of a binary image
function closed_img = closeEdges(binary_img,radius)
    se = strel('disk',radius); % create a disk shaped structuring element
    closed_img = imclose(binary_img,se); % close the boundaries of the image
end

function boundary_pix = traceExposedDome(edges) % trace the outline of the dome given a binary image of its edges
% return the indices of the pixels on the boundary

    filled_dome = imfill(edges,'holes'); % get a binary mask of the dome
    clean_size = 200; 
    cleaned_dome = bwareaopen(filled_dome,clean_size); % remove objects less than 200 pixels in size
    
    [boundaries,~,num_obj,~] = bwboundaries(cleaned_dome); % trace the boundary of the dome
    
    % if there's more than one object found, throw an exception
    if (num_obj > 1)
        errID = 'detectEdges:domeDetection:tooManyObj';
        msg = 'Custom message: detected more than one object when searching for the dome!';
        ME = MException(errID,msg);
        throw(ME)
    end 
    
    boundary_pix = boundaries{1}; %there should only be one boundary to trace
    
    hold on
    plot(boundary_pix(:,2),boundary_pix(:,1),'r','LineWidth',2); % show the boundary
    
    % TODO: get the bounding box of 'cleaned_dome' and use that for image cropping
    
end