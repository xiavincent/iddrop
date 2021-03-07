% return binary mask of camera shadow (defined by grayscale intensity below 80)
function shadow = getShadow(RGB_img) 
    gray_img = rgb2gray(RGB_img);
    thresh = 80;
    shadow = gray_img < thresh; % extract intensity values less than 80 to get camera shadow
    
    structuring_elem = strel('disk',15); 
    shadow = imdilate(shadow,structuring_elem); % expand the shadow area
end