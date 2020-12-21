% Detect the edges of a thin film
function detectEdges()
    %% add folders to path and pull frame of interest
    addPath();
    
    %% read in data
    RGB = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame659.tif');
    HSV = rgb2hsv(RGB);
    gray = rgb2gray(RGB);
    
    %% Get a mask of the dome
%     dome_mask = findDome(RGB); % NOTE: only run 'findDome' on the frame for area selection


    %% Get area mask
    area_frame = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame2330_AreaFrame.tif');
    area_mask = getAreaMask(area_frame); % NOTE: only run this on the area frame!
    
    %% Get black parts of image (for characterization of ultra-thin films)
%     getBlackPix(RGB);
      
    %% visualize edges
%     close all
%     sobel_step_size = 0;
%     sobel_sens = .0164*.5 + sobel_step_size; % sobel sensitivity
%     
%     step_high = 0.19;
%     can_sens = .0781 + step_high;   % alternative format:can_sens = [0.0312+step_low , 0.0781+step_high];
%     
%     showEdges(gray,sobel_sens,can_sens); % visualize the edges in a figure using given senstivities as settings
    
    %% segment film area from gradient magnitude  
%     wet_film = findFilmArea(gray,dome_mask);
%     
%     overlay = imoverlay(RGB,wet_film,'red'); % burn binary mask into original image
%     figure
%     imshow(overlay) % display result
    
    %% ImageJ-inspired Sobel detection
    edges = getEdges(gray); % get the edges
    film_edges = rmvDomeTrace(edges,area_mask); % apply an area mask to remove the dome
    
    figure
    imshow(film_edges);
    title('film edges');
    
    figure
    filled_film = imfill(film_edges,'holes');
    overlay = labeloverlay(RGB,filled_film); % burn binary mask into original image
    imshow(overlay);

end

%% Private helper functions

function addPath() % add subfolders to the path
    folder = fileparts(which(mfilename)); % currently running folder
    addpath(genpath(folder)); % Add the folder plus all subfolders to the path.
end

function area_mask = getAreaMask(frame)
    figure
    imshow(frame); % display the original frame

    xlabel('Draw circle around total area','FontSize',16,'FontName','Arial'); % user-specified cropping
    roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all"); 
    area_mask = createMask(roi);
end

% remove the dome edges from a binary image using an area mask
function edges_clean = rmvDomeTrace(edges, area_mask)
    edges(~area_mask) = 0; % clear pixels outside of area_mask
    edges_clean = edges; % return the cleaned version
end



