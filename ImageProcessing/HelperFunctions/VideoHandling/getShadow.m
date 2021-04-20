% Return binary mask of camera shadow (defined by grayscale intensity below 80)
function [shadow,shadow_area] = getShadow(RGB_img) 
    gray_img = rgb2gray(RGB_img);
    thresh = 80;
    shadow = gray_img < thresh; % extract intensity values less than 80 to get camera shadow
    
    structuring_elem = strel('disk',10);
    shadow = imdilate(shadow,structuring_elem); % expand the shadow area to encompass the edges  
    shadow_area = nnz(shadow);
end