% Find the exposed dome and return a mask of it
function dome_mask = findDome(RGB_img)

    gray_img = rgb2gray(RGB_img);
    [Gmag,~] = imgradient(gray_img);
    
    mag_img = mat2gray(Gmag); % convert to grayscale image
    binary = imbinarize(mag_img,'adaptive'); % turn grayscale into binary image
    binary_clean = bwareaopen(binary,200);
        
    dome = imfill(binary_clean,'holes');
    clean_size = 500; % remove objects smaller than 500 pixels
    dome_mask = bwareaopen(dome,clean_size);
    dome_mask = imclearborder(dome_mask); % clear the border of the mask

    ecc_range = [0 .5];
    dome_mask = bwpropfilt(dome_mask,'Eccentricity',ecc_range); % filter out objects outside of the range, leaving only the dome
        
end