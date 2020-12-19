% use a disk shape to morphologically close the edges of a binary image
function closed_img = closeEdges(binary_img)

    %TODO: change into 'bwmorph' bridge or thicken operation
%     se = strel('disk',radius); % create a disk shaped structuring element
%     closed_img = imclose(binary_img,se); % close the boundaries of the image
    
    num_it = 2;
    thickened = bwmorph(binary_img,'thicken',num_it); % thicken the boundaries 5 times
    closed_img = bwmorph(thickened,'bridge');
    
end


