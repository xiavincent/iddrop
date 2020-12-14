function detectEdges()
    
    RGB = imread('/Volumes/Extreme SSD/LubricinData/07 2020/7-18-20/1 ugmL HPL2/finalCode/frame6800.tif');
    gray = rgb2gray(RGB);
    
    %% visualize edges
    close all
    step_size = 0;
    sensitivity = .0164 + step_size; % sobel sensitivity
    
    sobel = edge(gray,'sobel',sensitivity);
    prewitt = edge(gray,'prewitt');
    roberts = edge(gray,'roberts');
    canny = edge(gray,'canny');
    approxcanny = edge(gray,'approxcanny');

    figure
    title(sprintf('Sensitivity: %.3f',sensitivity));
    montage({sobel,prewitt,roberts,canny,approxcanny})

    %% fill holes
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
   


end