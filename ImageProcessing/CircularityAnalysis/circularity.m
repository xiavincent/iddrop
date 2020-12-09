%% Perform a circularity analysis on a single frame

%% Params
framerate = 20;
finaltime = 600; % final time in seconds
%% Analysis

[img] = getImg(); % selected tiff


%%
t0 = 136; % change based on user selection
finalfnum = t0 + finaltime*framerate;

analyzeCirc(img);

%%

function [img] = getImg()
    [file,path] = uigetfile('/Users/Vincent/Desktop/0.25 ug/*.tif','Select an image' ); %choose .tif image
    fname = fullfile(path,file);
    img = imread(fname);
end


function wet_area = analyzeCirc(img) % a single frame circularity analysis

    gray_frame = rgb2gray(img); % grayscale frame from video 
    
    clr_brdr = imclearborder(gray_frame); % remove the image border and leave us with the dome only
    binarize_mask = imbinarize(clr_brdr,'global');
    
   
    binarize_mask_reduced = binarize_mask;
    binarize_mask_reduced(~analys.area_mask) = 0; % apply the area mask to get an accurate count of the area
    
    if(nnz(binarize_mask_reduced) > analys.film_area + 1000) % if the binarization fails to split image
        binarize_mask = zeros(size(binarize_mask)); % don't try to analyze the frame for dewetted area
    end

    % Apply each color band's particular thresholds to the color band
    hsv_frame = rgb2hsv(img); % convert to hsv image
    
	hueMask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); %makes mask of the value image within theshold values   
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask 

    combined_mask = HSV_mask & binarize_mask;    
    combined_mask(~analys.area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, params.rm_pix);
    combined_mask_fill = ~bwareaopen(~combined_mask_open, 20); % fill in small holes of the binarized mask
    
    % Clean the image and count the area
    [label_dewet_img, wet_area] = countArea(combined_mask_fill, analys.outer_region, analys.film_area, size(gray_frame));       

end