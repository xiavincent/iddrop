% TODO: test on videos from 12/11/20 to make sure method still works even when film is not
% completely deteched on its edges from the bath

% Works on 07-18-2020 and 11-05-2020 test videos
% Works moderately well on 12/11/20 HPL2 37C SLB MUC
% Doesn't work on 12/11/20 HPL3 RT1 SLB MUC


% Detect the edges of a thin film
function detectEdges()
    %% add folders to path and pull frame of interest
    addPath();
    
    %% read in single frame
%   [RGB,HSV,gray] = readFrame('/Users/Vincent/LubricinDataLocal/11_05_2020/0.25 ug/TestFrames/batchProcess/*.tif');
    
    %% batch process frames in a single folder
%     img_path = '/Volumes/Extreme SSD/12-11-2020/PBS HPL2 37C 1 SLB MUC/TestFrames/*.tif';
%     images = readBatch(img_path); % get a cell array of all the images
% 
%     %% Analyze the area frame
%     area_frame = imread('/Volumes/Extreme SSD/12-11-2020/PBS HPL2 37C 1 SLB MUC/TestFrames/skip100_0009.tif');
%     area_mask = getAreaMask(area_frame); % NOTE: must run videoprocessing file first to load the getAreaMask function
    %% Get camera shadow mask
%     camera_mask = getShadow(area_frame); % extract mask of camera shadow using intensity values

    %% Get a mask of the dome
%     dome_mask = findDome(area_frame); % Get a mask of the dome
                                        % NOTE: only run 'findDome' on the area selection frame!                     
    
    %% Get black parts of image (for characterization of ultra-thin films)
%     getBlackPix(RGB);
    
    %% ImageJ-inspired Sobel detection

    % TODO: implement automatic dome finding for image cropping; expand size
    
    % TODO: make sure I can successfully process any images after the separation of the film
        % from the edge of the dome
    
    tic
    start = 1; % first image index to analyze
    finish = 10; % last image index to analyze
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





