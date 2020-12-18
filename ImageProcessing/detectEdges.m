% Detect the edges of a thin film
function detectEdges()
    
    RGB = imread('/Volumes/Extreme SSD/LubricinData/07 2020/7-18-20/1 ugmL HPL2/finalCode/frame6800.tif');
    HSV = rgb2hsv(RGB);
    gray = rgb2gray(RGB);
    
    %% Get black parts of of image
    
    getBlack(RGB);
      
    %% visualize edges
    close all
    sobel_step_size = 0;
    sobel_sens = .0164 + sobel_step_size; % sobel sensitivity
    
    step_high = 0.19;
    can_sens = .0781 + step_high;   % alternative format:can_sens = [0.0312+step_low , 0.0781+step_high];
    
    showEdges(gray,sobel_sens,can_sens); % visualize the edges in a figure using given senstivities as settings
    
    %% gradient visualization    
    filled_wet_area = showGradients(gray);
    overlay = imoverlay(RGB,filled_wet_area,'red'); % burn binary mask into original image
    figure
    imshow(overlay) % display result
    
    %% Single direction sobel detection
    showDirSobel(gray);

end


function getBlack(RGB_img) % takes an RGB image and gets the black pixels from it

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

%% Helper functions
% show image edges using various edge detection algorithms
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

% show the Sobel gradients and magnitudes of a grayscale image
function filled = showGradients(gray_img)
    figure
    [Gx,Gy] = imgradientxy(gray_img);
    imshowpair(Gx,Gy,'montage')
    title('Directional Gradients Gx and Gy, Using Sobel Method')
    
    figure
    [Gmag,Gdir] = imgradient(Gx,Gy);
    imshowpair(Gmag,Gdir,'montage')
    title('Gradient Magnitude (Left) and Gradient Direction (Right)')
    
    filled = floodFill(Gmag); % flood fill gradient magnitude image and export result
end

function filled = floodFill(gradient_magnitude) % flood fill wetted portion of gradient image

    mag_img = mat2gray(gradient_magnitude); % convert to grayscale
    
    f = figure;
    ax = axes(f);
    imshow(mag_img,'Parent',ax);
    title(ax,'grayscale gradient magnitude image');
   
    bin = imbinarize(mag_img);
    skel = bwskel(bin); % get the skeleton mask of the image
    
    
    
    
%     mag_filled = imfill(bin,[200 450]); % flood fill operation of interior of film
%     
%     figure
%     imshow(mag_filled)
%     title('flood fill film interior')
%     
%     figure
%     imshow(~mag_filled) % invert image to capture dewetted region
%     title('inverted film interior')
%     
%     figure
%     edge_fill = imfill(bin,[300 300]); % flood fill exterior of film
%     imshow(edge_fill)
%     title('flood fill film exterior')
%     
    
    figure
    imshow(skel)
    bndry = traceDome(skel);
    
    for i=1:length(bndry)
        skel(bndry(i,1),bndry(i,2)) = 0; % remove the boundary of the dome from the image
    end
    
    filled = imfill(skel,'holes'); % flood fill film by removing the dome's edges first
    imshow(filled)
    
    % Works moderately well; expect some variation in film area inclusion based on edge
    % detection
    % TODO: test on different frames
    
end

function showDirSobel(gray_img)

    vertical_edges = edge(gray_img,'sobel','vertical');
    horizontal_edges = edge(gray_img,'sobel','horizontal');
    
    figure
    hold on
    combined = bitor(vertical_edges,horizontal_edges);
    imshow(combined)
    title('combined x- and y-directional sobel edges');
    
    bndry = traceDome(combined); % trace the dome and return the indices of the pixel boundaries
    
    for i=1:length(bndry)
        combined(bndry(i,1),bndry(i,2)) = 0; % remove the boundary of the dome from the image
    end    
    
    figure
    imshow(combined)
    
    % NOTE: doesn't work because directional sobel can't adequately detect film edges
         
end

function boundary_pix = traceDome(edges) % trace the outline of the dome given a binary image of its edges
% return the indices of the pixels on the boundary

    filled_dome = imfill(edges,'holes');
   
    clean_size = 200; % remove objects less than 200 pixels in size
    cleaned_dome = bwareaopen(filled_dome,clean_size); 
    
    [boundaries,~,num_obj,~] = bwboundaries(cleaned_dome); % trace the boundary of the dome
    
    % if there's more than one object found, throw an exception
    if (num_obj > 1)
        errID = 'Dome detection';
        msg = 'detected more than one object when searching for the dome';
        ME = MException(errID,msg);
        throw(ME)
    end 
    
    boundary_pix = boundaries{1}; %there should only be one boundary to trace
    
    hold on
    plot(boundary_pix(:,2),boundary_pix(:,1),'r','LineWidth',2); % show the boundary
    
    % TODO: get the bounding box of 'cleaned_dome' and use that for image cropping
    
end