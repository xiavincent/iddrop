% Skeletonize a binary image and remove the exposed dome's edges, returning the result
function skel = removeDomeEdges(binary) 
    
    skel = bwmorph(binary,'skel',Inf); % get the skeleton mask of the image || alternative function: bwskel
  
    clean_size = 200;
    clean_skel = bwareaopen(skel,clean_size); % remove small objects
    ecc_range = [0 .5];
    filtered = bwpropfilt(clean_skel,'Eccentricity',ecc_range); % filter out non-circular objects, leaving only the dome

    bndry = traceExposedDome(filtered); % find the boundary of the dome
    
    for i=1:length(bndry)
        skel(bndry(i,1),bndry(i,2)) = 0; % remove the boundary of the dome from the image
    end
end


