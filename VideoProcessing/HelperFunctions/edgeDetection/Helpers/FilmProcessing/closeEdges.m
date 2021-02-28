%% FUNCTION
% use line shape to morphologically close the edges of a binary image
function closed_edges = closeEdges(film_edges,size)
    line_len = 2*size; % make a dilation structuring element with twice the size to grow the edges
    se0 = strel('line',line_len,0); % horizontal line structuring element 
    se90 = strel('line',line_len,90); % vertical line structuring element
    closed_edges = imdilate(film_edges,[se0 se90]);
    closed_edges = bwmorph(closed_edges,'bridge'); % bridge the mask's edges
end