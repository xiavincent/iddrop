%% Main function
function tests = testArea
    tests = functiontests(localfunctions);
end


%% Test functions
function testEdgeAlg(testCase)
    HSV_bw_mask = testCase.TestData.HSV_bw_mask;
    gray_frame = testCase.TestData.gray_frame;
    area_fit_type = testCase.TestData.area_fit_type;
    outer_region  = testCase.TestData.outer_region;
    
    img_size = size(gray_frame);

    [final_mask, ~] = countArea(HSV_bw_mask,outer_region,img_size,area_fit_type);
    final_mask = im2uint8(final_mask~=0);
    imshow(final_mask);
    
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    %initialize param's
    file_name = '/Volumes/Extreme SSD/11:5:20/0.25 ug/0.25 ugmL lubricin AS HPL1 NR 37C 1.avi';
    cur_frame_num = 2686; %916 % 1576
    remove_Pixels = 250;
    area_frame_num = 1940;
    area_fit_type = 1; % freehand fit
    hueThresholdLow = .422;
    hueThresholdHigh = .500;
    saturationThresholdLow = .104; 
    saturationThresholdHigh = .271; 
    valueThresholdLow = .490; 
    valueThresholdHigh = .761;
    
    crop_start = [150,50]; % upper left hand corner for cropping rectangle
    crop_size = [700,700]; % crop size
    crop_rect = [crop_start, crop_size-1]; % cropping rectangle || subtract one to make it exactly 700 by 700 in size
    
    % setup video 
    video = VideoReader(file_name); % starts reading video
    background_frame_num = 141; % change
    background_frame = read(video, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    background_frame_cropped = imcrop(rgb2gray(background_frame),crop_rect); % Converts to grayscale and crops size                                                              
    
    % setup area frame
    totalareaframe        = read(video,area_frame_num);                % Read user specified frame for area analysis
    totalareaframecropped = imcrop(totalareaframe,crop_rect);     % Crop area frame
    [area_mask, outer_region, ~, shadow_mask, ~] = userdrawROI(totalareaframecropped,area_fit_type); %helper function to handle our ROI drawing
      
    orig_frame=read(video,cur_frame_num); % reading individual frames from input video
    crop_frame=imcrop(orig_frame,crop_rect); 
    gray_frame=rgb2gray(crop_frame); % grayscale frame from video

    subtract_frame = gray_frame - background_frame_cropped; % Subtract background frame from current frame
    subtract_frame(shadow_mask) = 0; %apply the camera mask
    subtract_frame(~area_mask) = 0; %apply area mask
    bw_frame_mask=imbinarize(subtract_frame);
    
    hsv_frame = rgb2hsv(crop_frame); % convert to hsv image
    
    % Apply each color band's particular thresholds to the color band
	hueMask = (hsv_frame(:,:,1) >= hueThresholdLow) & (hsv_frame(:,:,1) <= hueThresholdHigh); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= saturationThresholdLow) & (hsv_frame(:,:,2) <= saturationThresholdHigh); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= valueThresholdLow) & (hsv_frame(:,:,3) <= valueThresholdHigh); %makes mask of the value image within theshold values   
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask 

    combined_mask = HSV_mask & bw_frame_mask;
    combined_mask(shadow_mask) = 0; % apply camera mask
    combined_mask(~area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, remove_Pixels);
    
    
    testCase.TestData.HSV_bw_mask = combined_mask_open;  % apply binarization mask
    
    testCase.TestData.area_center = [500 439];
    testCase.TestData.area_radius = 230.3845;
    testCase.TestData.gray_frame = gray_frame;
    testCase.TestData.area_fit_type = 1; % freehand fit
    testCase.TestData.outer_region = outer_region;
end



function teardownOnce(testCase)  % do not change function name
    % clear all test case data
end



%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    figure('Name','Final Processed Frame','NumberTitle','off');
end

function teardown(testCase)  % do not change function name
% close figure, for example
end