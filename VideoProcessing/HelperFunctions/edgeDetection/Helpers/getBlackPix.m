% Takes an RGB image and shows the black pixels in it
function getBlackPix(RGB_img) 

    HSV = rgb2hsv(RGB_img);
%     h_img = HSV(:,:,1);
    s_img = HSV(:,:,2);
    v_img = HSV(:,:,3);
    
    s_thresh = 0.3;
    gray_mask = s_img < s_thresh; % get gray colors
    
    v_thresh_low = 0.6; % threshold on value component to find dark pixels
    dark_pix = v_img < v_thresh_low;
    black_pix = dark_pix & gray_mask; % find black pixels

    figure
    imshow(imoverlay(RGB_img,black_pix,'red'));
    title('black pixels')
end
