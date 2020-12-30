% show image edges using several edge detection algorithms
function showEdges(gray_img, sobel_sensitivity, can_sensitivity) 

    sobel = edge(gray_img,'sobel',sobel_sensitivity);
    prewitt = edge(gray_img,'prewitt');
    roberts = edge(gray_img,'roberts');
    canny = edge(gray_img,'canny',can_sensitivity);
    approxcanny = edge(gray_img,'approxcanny',can_sensitivity);
    figure
    montage({sobel,prewitt,roberts,canny,approxcanny})
    title(sprintf(['Sobel, prewitt, roberts, canny, and approxcanny algorithms (left to right, top to bottom) \n',...   
                'Sobel sensitivity: %.3f | Canny sensitivity: %.3f'],sobel_sensitivity,can_sensitivity));
            
    % fill edge holes
    fillHoles(sobel,prewitt,roberts,canny,approxcanny); % fill in the holes on the input images and show a montage of the results

end

% fill the holes of a variable number of input images and display the result in a montage
function fillHoles(varargin)
    filled = cell(1,nargin); % store the output images
    for i = 1:nargin
        filled{i} = imfill(varargin{i},'holes');
    end
    
    figure;
    montage(filled);
    title('Edges with filled holes');
end