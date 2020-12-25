% TODO: test on videos from 12/11/20 to make sure method still works even when film is not
% completely deteched on its edges from the bath

% Works on 07-18-2020 and 11-05-2020 test videos


% Detect the edges of a thin film
function detectEdges()
    %% add folders to path and pull frame of interest
    addPath();
    
    %% read in single frame
%   [RGB,HSV,gray] = readFrame('/Users/Vincent/LubricinDataLocal/11_05_2020/0.25 ug/TestFrames/batchProcess/*.tif');
    
    %% batch process frames in a single folder
    path = "/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/batchProcessFrames/*.tif";
    images = readBatch(path); % get a cell array of all the images

    %% Analyze the area frame
    area_frame = imread('/Users/Vincent/LubricinDataLocal/07_18_2020/TestFrames/frame2330_AreaFrame.tif');
    area_mask = getAreaMask(area_frame); % NOTE: must run videoprocessing file first to load the getAreaMask function
    
%     dome_mask = findDome(area_frame); % Get a mask of the dome
                                        % NOTE: only run 'findDome' on the area selection frame!
    
    %% Get black parts of image (for characterization of ultra-thin films)
%     getBlackPix(RGB);
    
    %% ImageJ-inspired Sobel detection
    
    % TODO: segment out the camera shadow first using grayscale interpolation with surrounding
        % pixels
    % TODO: implement automatic dome finding for image cropping; expand size
    % TODO: implement parallel processing toolbox detection
    % TODO: make sure I can successfully process any images after the separation of the film
        % from the edge of the dome
    
    
    tic
    start = 125; % first image index to analyze
    finish = 125; % last image index to analyze
    processImages(start,finish,images,area_mask)
    toc
    
    
    % OBSERVATIONS:
        % some difficulty on earlier frames (e.g., images 1 & 2)
        % should add in camera removal as the first step before finding film area
        % low solidity objects are being included in images 14 & 15. should filter by
            % solidity/convexity or image extent
        % this method will only work if the film is intact as a single piece
            
    % PERFORMANCE:
        % the run-time to process 100 frames without mask overlay, is ~6 sec
        % for a 12,000 frame video where every 30 frames are analyzed, the expected runtime is
            % ~24 sec 
       
end

%% Private helper functions

function addPath() % add subfolders to the path
    folder = fileparts(which(mfilename)); % currently running folder
    addpath(genpath(folder)); % Add the folder plus all subfolders to the path.
end


% get a mask of the total area
function area_mask = getAreaMask(frame)

    area_fit_type = 0; % freehand fit
   
    [area_mask,~,~,~] = userdrawROI(frame,area_fit_type); % helper function from original code

%     figure
%     imshow(frame); % display the original frame
% 
%     xlabel('Draw circle around total area','FontSize',16,'FontName','Arial'); % user-specified cropping
%     roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all"); 
%     area_mask = createMask(roi);
end


% read a single image frame from a character vector of the file name
% return the RGB, HSV, and grayscale intensity versions of the image
function [RGB,HSV,grayscale] = readFrame(file_name)
    RGB = imread(file_name);
    HSV = rgb2hsv(RGB);
    grayscale = rgb2gray(RGB);
end

function frames = readBatch(folder_path)
    files = dir(folder_path);
    
    frames = cell([1 length(files)]);
    for i=1:length(files) % read files into a cell array of structs
        base_name = files(i).name;
        fname = fullfile(files(i).folder,base_name);
        [frames{i}.frame,~,~] = readFrame(fname);
        frames{i}.num = str2double(base_name(end-7:end-4)); % grab the last 4 digits
    end
end



