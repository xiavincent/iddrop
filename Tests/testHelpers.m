%% Main function
function tests = testHelpers
    tests = functiontests(localfunctions);
end


%% Test functions
function testEdgeAlg(testCase)
    HSV_bw_mask = testCase.TestData.HSV_bw_mask;
    gray_frame = testCase.TestData.gray_frame;
    area_center = testCase.TestData.area_center;
    area_radius = testCase.TestData.area_radius;

    [final_mask, dewet_area] = countArea(HSV_bw_mask,gray_frame,area_center,area_radius);
    final_mask = im2uint8(final_mask~=0);
    imshow(final_mask);
    
%     dewet_area;
end


%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    %initialize param's
    file_name = '/Volumes/Extreme SSD/11:5:20/0.25 ug/0.25 ugmL lubricin AS HPL1 NR 37C 1.avi';
    cur_frame_num = 2500; % change
    remove_Pixels = 250;
    area_frame_num = 1940;
    area_fit_type = 0; %freehand fit
    hueThresholdLow = .422;
    hueThresholdHigh = .500;
    saturationThresholdLow = .104; 
    saturationThresholdHigh = .271; 
    valueThresholdLow = .490; 
    valueThresholdHigh = .761;
    
    % setup video 
    video = VideoReader(file_name); % starts reading video
    background_frame_num = 141; % change
    background_frame = read(video, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    background_frame_cropped = imcrop(rgb2gray(background_frame),[0,0,1024,768]); % Converts to grayscale and crops size                                                              
    
    % setup area frame
    totalareaframe        = read(video,area_frame_num);                % Read user specified frame for area analysis
    totalareaframecropped = imcrop(totalareaframe,[0,0,1024,768]);     % Crop area frame
    totalareaframegray    = rgb2gray(totalareaframecropped);           % Grayscale area frame
    [mask, max_area, shadowMask, camera_area, area_center, area_radius] = userdraw_ROI(totalareaframecropped,area_fit_type); %helper function to handle our ROI drawing
      
    orig_frame=read(video,cur_frame_num); % reading individual frames from input video
    crop_frame=imcrop(orig_frame,[0,0,1024,768]); 
    gray_frame=rgb2gray(crop_frame); % grayscale frame from video

    
    subtract_frame=gray_frame - background_frame_cropped; % Subtract background frame from current frame
    subtract_frame(shadowMask) = 0; %clear every subtract_frame pixel inside the shadowMask | applies the camera mask
    subtract_frame(~mask) = 0; %apply area mask
    bw_frame_mask=imbinarize(subtract_frame);
    bw_frame_mask_clean = bwareaopen(bw_frame_mask, remove_Pixels); % remove connected objects that are smaller than 250 pixels in size
    bw_frame_mask_clean = ~bwareaopen(~bw_frame_mask_clean, remove_Pixels); % remove holes that are smaller than 20 pixels in size

    hsv_frame=rgb2hsv(crop_frame); % convert to hsv image
    hsv_frame(shadowMask) = 0; % apply camera mask
    hsv_frame(~mask) = 0; % apply area mask
    
    % Apply each color band's particular thresholds to the color band
	hueMask = (hsv_frame(:,:,1) >= hueThresholdLow) & (hsv_frame(:,:,1) <= hueThresholdHigh); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= saturationThresholdLow) & (hsv_frame(:,:,2) <= saturationThresholdHigh); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= valueThresholdLow) & (hsv_frame(:,:,3) <= valueThresholdHigh); %makes mask of the value image within theshold values
    
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask   
	HSV_mask_rmv_maskHoles = ~bwareaopen(~HSV_mask, remove_Pixels); % Fill in the holes of the mask 
    HSV_mask_rmv_obj = bwareaopen(HSV_mask_rmv_maskHoles, remove_Pixels); %fill in holes smaller than 250 pixels in size
    testCase.TestData.HSV_bw_mask = HSV_mask_rmv_obj & bw_frame_mask_clean;  % apply binarization mask
   
    testCase.TestData.area_center = [500 439];
    testCase.TestData.area_radius = 230.3845;
    testCase.TestData.gray_frame = gray_frame;
end



function teardownOnce(testCase)  % do not change function name
    % change back to original path, for example
end



%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    figure;
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end