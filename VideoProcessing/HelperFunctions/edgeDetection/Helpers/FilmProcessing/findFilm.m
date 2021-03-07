% create a mask of the film area from an RGB image, using the area_mask as a helper parameter
function film_mask = findFilm(RGB_img,dome_mask,cam_mask,seed_rc) 
   
    grayscale_img = rgb2gray(RGB_img);

    raw_edges = getEdges(grayscale_img); % get the edges
    raw_edges = rmEdges(raw_edges,dome_mask); % remove dome edges
    raw_edges = rmEdges(raw_edges,~cam_mask); % remove camera shadow edges
    
    grow_bdry = 2; % number of pixels we expand edge boundaries
    film_edges = closeEdges(raw_edges,grow_bdry);
        
    filled_film = imfill(film_edges,seed_rc); % convert seed location to row/column indexing and fill in the film area

    min_size = 7000; % camera shadow size measured on ImageJ
    max_size = 190000; % empirical measurement of maximum dome area on ImageJ
    film_mask = bwareafilt(filled_film,[min_size max_size]); % filter out small objects so we retain only the main film
    
%     film_mask = smoothMask(film_mask); % comment out and don't smooth mask for increased performance
end


%% PRIVATE HELPER FUNCTIONS

% perform morphological erosion to smooth a mask
function smoothed_mask = smoothMask(film_mask)
    seD = strel('diamond',1); % diamond shaped structuring element
    smoothed_mask = imerode(film_mask,seD);
    smoothed_mask = imerode(smoothed_mask,seD);
end


% remove the edges from a binary image outside of an input mask
function edges = rmEdges(edges, mask)
    edges(~mask) = 0; % clear pixels outside of area_mask
end

 

