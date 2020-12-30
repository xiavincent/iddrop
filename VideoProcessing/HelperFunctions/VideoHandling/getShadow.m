% return binary mask of camera shadow (defined by grayscale intensity below 100)
function shadow = getShadow(RGB_img) 
    gray_img = rgb2gray(RGB_img);
    thresh = 80;
    shadow = gray_img < thresh; % extract intensity values less than 100 to get camera shadow
    
    structuring_elem = strel('disk',10); 
    shadow = imdilate(shadow,structuring_elem); % expand the shadow area    
end