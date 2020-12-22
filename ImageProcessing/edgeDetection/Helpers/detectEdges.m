% Detect the edges of a thin film
function detectEdges()
    %% add folders to path and pull frame of interest
    addPath();
    
    %% read in single frame
    RGB = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame6800.tif');
    HSV = rgb2hsv(RGB);
    gray = rgb2gray(RGB);
    
    %% batch process frames
    path = "/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/batchProcessFrames/*.tif";
    files = dir(path);
    
    images = cell([1 length(files)]);
    for i=1:length(files) % read files into a cell array of structs
        base_name = files(i).name;
        fname = fullfile(files(i).folder,base_name);
        images{i}.frame = imread(fname);
        images{i}.num = str2double(base_name(end-7:end-4)); % grab the last 4 digits
    end
    


    %% Get area mask
    area_frame = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame2330_AreaFrame.tif');
    area_mask = getAreaMask(area_frame); % NOTE: only run this on the area frame!
    
    %% Get a mask of the dome
    dome_mask = findDome(area_frame); % NOTE: only run 'findDome' on the area selection frame!

    
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
%     wet_film = findSobelMagFilm(gray,dome_mask);
%     
%     overlay = imoverlay(RGB,wet_film,'red'); % burn binary mask into original image
%     figure
%     imshow(overlay) % display result
    
    %% ImageJ-inspired Sobel detection
    
    % TODO: segment out the camera shadow first
    % TODO: implement automatic dome finding
    
    
    for i=11:20
        RGB = images{i}.frame;
        gray = rgb2gray(RGB);
        film_mask = findFilm(gray,area_mask); % return a mask of the wet film

        overlay = labeloverlay(RGB,film_mask); % burn binary mask into original image
        fig = figure;
        ax = axes(fig);
        imshow(overlay,'parent',ax);
        title(sprintf('Wet film overlay: image %d',images{i}.num));
    end

    % OBSERVATIONS:
        % some difficulty on earlier frames (e.g., images 1 & 2)
        % should add in camera removal as the first step before finding film area
        % low solidity objects are being included in images 14 & 15. should filter by
            % solidity/convexity or image extent
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

function film_mask = findFilm(grayscale_img,area_mask) % create a mask of the film area from a grayscale image, using the area_mask as a helper parameter

    edges = getEdges(grayscale_img); % get the edges
    film_edges = rmvDomeTrace(edges,area_mask); % apply an area mask to remove the dome
%     figure
%     imshow(film_edges);
%     title('film edges');
    
    film_edges = bwmorph(film_edges,'bridge'); % close the mask's edges
%     figure
%     imshow(film_edges);
%     title('film edges after bridging');
    
    filled_film = imfill(film_edges,'holes');
    min_size = 7000; % camera shadow size measured on ImageJ
    max_size = 190000; % empirical measurement of maximum dome area on ImageJ
    
    film_mask = bwareafilt(filled_film,[min_size max_size]); % filter out small objects so we retain only the main film
    
end



% remove the dome edges from a binary image using an area mask
function edges_clean = rmvDomeTrace(edges, area_mask)
    edges(~area_mask) = 0; % clear pixels outside of area_mask
    edges_clean = edges; % return the cleaned version
end




