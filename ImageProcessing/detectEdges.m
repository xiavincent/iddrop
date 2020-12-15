% Detect the edges of a thin film
% function detectEdges()
    
    RGB = imread('/Volumes/Extreme SSD/LubricinData/07 2020/7-18-20/1 ugmL HPL2/finalCode/frame6800.tif');
    gray = rgb2gray(RGB);
    
    %% visualize edges
    close all
    sobel_step_size = 0;
    sensitivity = .0164 + sobel_step_size; % sobel sensitivity
    
    
    step_low = 0;
    step_high = 0.19;
%     cam_sensitivity = [0.0312+step_low , 0.0781+step_high];
    cam_sensitivity = .0781 + step_high;
    
    sobel = edge(gray,'sobel',sensitivity);
    prewitt = edge(gray,'prewitt');
    roberts = edge(gray,'roberts');
    canny = edge(gray,'canny',cam_sensitivity);
    approxcanny = edge(gray,'approxcanny',cam_sensitivity);
    figure
    title(sprintf('Sensitivity: %.3f',cam_sensitivity));
    montage({sobel,prewitt,roberts,canny,approxcanny})

    %% fill edge holes
    sobel_fill = imfill(sobel,'holes');
    prewitt_fill = imfill(prewitt,'holes');
    roberts_fill = imfill(roberts,'holes');
    canny_fill = imfill(canny,'holes');
    approx_fill = imfill(approxcanny,'holes');
    figure
    montage({sobel_fill,prewitt_fill,roberts_fill,canny_fill,approx_fill});

    
    
    
    
    
    
    
    
    %% gradient visualization
    figure
    [Gx,Gy] = imgradientxy(gray);
    imshowpair(Gx,Gy,'montage')
    title('Directional Gradients Gx and Gy, Using Sobel Method')
    
    figure
    [Gmag,Gdir] = imgradient(Gx,Gy);
    imshowpair(Gmag,Gdir,'montage')
    title('Gradient Magnitude (Left) and Gradient Direction (Right)')
    
    
    %% Flood fill gradient image
    mag_img = mat2gray(Gmag); % convert to grayscale
    imshow(mag_img)
    bin = imbinarize(mag_img);
%     mag_filled = imfill(bin,[300 300]); % flood fill operation of outside
    mag_filled = imfill(bin,[200 450]); % flood fill operation of interior of film
    imshow(mag_filled)
    imshow(~mag_filled) % invert image to capture dewetted region
    
    
    %% Single direction sobel detection
    
    vertical_edges = edge(gray,'sobel','vertical');
    horizontal_edges = edge(gray,'sobel','horizontal');
    
    combined = bitor(vertical_edges,horizontal_edges);
    edge_fill = imfill(bin,[300 300]); % flood fill image
    imshow(edge_fill)

% end