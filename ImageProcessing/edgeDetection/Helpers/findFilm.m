% create a mask of the film area from a grayscale image, using the area_mask as a helper parameter
function film_mask = findFilm(grayscale_img,area_mask) 

    edges = getEdges(grayscale_img); % get the edges
    film_edges = rmvDomeTrace(edges,area_mask); % apply an area mask to remove the dome
    film_edges = closeEdges(film_edges);
    
    filled_film = imfill(film_edges,'holes');
    min_size = 7000; % camera shadow size measured on ImageJ
    max_size = 190000; % empirical measurement of maximum dome area on ImageJ
    
    film_mask = bwareafilt(filled_film,[min_size max_size]); % filter out small objects so we retain only the main film
    
    film_mask = smoothMask(film_mask); % don't smooth mask for increased performance
    
end


% use line shape to morphologically close the edges of a binary image
function closed_edges = closeEdges(film_edges)
    line_len = 2;
    se0 = strel('line',line_len,0); % horizontal line structuring element 
    se90 = strel('line',line_len,90); % vertical line structuring element
    closed_edges = imdilate(film_edges,[se0 se90]);
    closed_edges = bwmorph(closed_edges,'bridge'); % bridge the mask's edges
end


% perform morphological erosion to smooth a mask
function smoothed_mask = smoothMask(film_mask)
%     figure
%     imshow(film_mask)
%     title('unsmoothed film mask')
    
    seD = strel('diamond',1); % diamond shaped structuring element
    smoothed_mask = imerode(film_mask,seD);
    smoothed_mask = imerode(smoothed_mask,seD);
%     
%     figure
%     imshow(smoothed_mask)
%     title('smoothed mask');
end


% remove the dome edges from a binary image using an area mask
function edges_clean = rmvDomeTrace(edges, area_mask)
    edges(~area_mask) = 0; % clear pixels outside of area_mask
    edges_clean = edges; % return the cleaned version
end