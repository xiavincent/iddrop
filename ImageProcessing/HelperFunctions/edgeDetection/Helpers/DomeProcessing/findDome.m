% Find the exposed dome from an RGB image and return a mask of it
function dome_mask = findDome(RGB_img)
%     gray_img = rgb2gray(RGB_img);
%     [Gmag,~] = imgradient(gray_img);
%     
%     mag_img = mat2gray(Gmag); % convert to grayscale image
%     binary = imbinarize(mag_img,'adaptive'); % turn grayscale into binary image
%     binary_clean = bwareaopen(binary,200);

    grayscale_img = rgb2gray(RGB_img);
    edges = getEdges(grayscale_img); % get the edges
    dome = imfill(edges,'holes');
    
    area_range = [100000 300000]; % acceptable dome size between 100k and 300k pixels
    dome_mask = bwareafilt(dome,area_range);
    
end