%% Description
% This file helps you establish proper hue, saturation, and value thresholds for use in 
% image processing files. Hover over each of the images to establish thresholding values that
% adequately encompass dry areas. Then, try these values out in the "Parameters" section of the
% code. If the thresholding values are accurate, the bottom left image entitled 'bwareaopen() 
% removed objects\nsmaller than %d pixels' should display the dewetted regions in white, and
% the wet regions in black.

%% Clear everything
clear all;
close all hidden;
clc;
 warning('off','all'); %Suppress warnings for faster exec.'
%% Parameters

% Threshold values for "5 ugmL lubricin DS 37C 1.avi" from 07-01-2020, frame 12448
% hueThresholdLow = 0;
% hueThresholdHigh = .3;
% saturationThresholdLow = 0;
% saturationThresholdHigh = .2;
% valueThresholdLow = .49;
% valueThresholdHigh = .56;

% hueThresholdLow = 0;
% hueThresholdHigh = 1; %.25
% saturationThresholdLow = 0;
% saturationThresholdHigh = .15;
% valueThresholdLow = .5;
% valueThresholdHigh = .6;


%For 3/5/20 video:
% 
% hueThresholdLow = 0;
% hueThresholdHigh = .65;
% saturationThresholdLow = 0;
% saturationThresholdHigh = .15;
% valueThresholdLow = .5;
% valueThresholdHigh = .7;


% For 07-07-18 1ugmL Lubricin DS HPL2
% hueThresholdLow = .45; %.4
% hueThresholdHigh = .6;
% saturationThresholdLow = 0;
% saturationThresholdHigh = .2;
% valueThresholdLow = 0.5; %.45
% valueThresholdHigh = .6;

% 07-18-20
hueThresholdLow = .404; 
hueThresholdHigh = .496;
saturationThresholdLow = .147;
saturationThresholdHigh = .236;
valueThresholdLow = .502; 
valueThresholdHigh = .780;

    
%% Input dialog for video filename
[file,path] = uigetfile('*.avi');
input_dialog = inputdlg({'Remove objects smaller than X pixels 100-1000 ','Select video frame for analysis','t_0? (when dome crosses interface?)'}, 'Sample', [1 50; 1 20; 1 20],{'250','1000', '85'});
fname=strcat(path,file);
%fname= 'C:\Users\Fuller\Documents\Dewetting\20181128\BSM_0.1mgml_PBS_noCaMg_1.0mmabove_1.0mmdown_1mms_hydrophobic unoated_clean by ethyl alcohol_37C_T3.avi'

thresh_level = 0;
remove_Pixels = str2double(input_dialog{1});
analysis_frame = str2double(input_dialog{2});
t_0 = str2double(input_dialog{3}); % T=0 frame value. Change depending on when dome crosses interface
bg = t_0 + 5; % Background is 5 frames + t_0 - to elimate the noisy data(waves/reflections etc)



%% Video Import
video=VideoReader(fname);   % starts reading video
fname=fname(1:end-4);       % removes .avi or other file extension from filename
nframes = video.NumFrames;  % gets # of frames in video
input_fps=video.FrameRate;  % gets frames/second in initial video
vidHeight = video.Height;   % gets video height
vidWidth = video.Width;     % gets video width
background_frame = read(video, bg);
% Subtract Background
background=imcrop(rgb2gray(background_frame),[0,0,1024,768]); %background frame is when dome crosses interface

%% Set total area
% totalareaframe        = read(video,analysis_frame);            % Read user-specified analysis frame to determine total area
totalareaframe = read(video,2300); % Read frame to determine total area
totalareaframecropped = imcrop(totalareaframe,[0,0,1024,768]); % Crop last frame
totalareaframegray    = rgb2gray(totalareaframecropped);        % Grayscale last frame
trial = 0;
while trial >= 0
    imshow(totalareaframegray);                                 % Show last frame as total area input
    xlabel('First click on the center of the circle, then click on the edge of the circle','FontSize',16,'FontName','Arial');
    [X,Y]         = ginput(2);                                  % Graphical input of 2 points (center and radius)
    squaredradius = (X(1)-X(2))^2+(Y(1)-Y(2))^2;                % Calculate squared radius
    roundradius   = round(squaredradius/100)*100;               % Round squared radius to hundred
    for i = 1:size(totalareaframegray,1)
        for j = 1:size(totalareaframegray,2)
            X(3)         = j;                                   % Pixel location X
            Y(3)         = i;                                   % Pixel location Y
            compare      = (X(1)-X(3))^2 + (Y(1)-Y(3))^2;       % Calculate squared radius for comparisson
            roundcompare = round(compare/100)*100;              % Round squared radius for comparisson to hundred
            if(roundcompare == roundradius)
                BW(i,j) = 1;                                    % Specify pixels as 1
            else
                BW(i,j) = 0;                                    % Specify pixels as 0
            end
        end
    end
    hold on;                                                    % Plot multiple data in one figure 
    spy(BW,'r',10);                                              % Plot pixels specified as 1
    hold off;                                                   % End plot multiple data in one figure
    areacheck = questdlg('Corresponds the red circle with the circle on the image?',...
        'Area check',...
        'Yes',...
        'No',...
        'Yes');
    switch areacheck,
        case 'Yes',
            for i = 1:size(totalareaframegray,1)
                for j = 1:size(totalareaframegray,2)
                    X(3)         = j;                                   % Pixel location X
                    Y(3)         = i;                                   % Pixel location Y
                    compare      = (X(1)-X(3))^2 + (Y(1)-Y(3))^2;       % Calculate squared radius for comparisson
                    if(compare <= squaredradius)
                        mask(i,j) = 1;                                    % Specify pixels as 1
                    else
                        mask(i,j) = 0;                                    % Specify pixels as 0
                    end
                end
            end
            max_area = nnz(mask);            
            break                                               % Quit while-loop
        case 'No',
            trial = trial + 1;                                  % Redo while-loop
    end
end
close;


%% Displaying video HSV images
for i=analysis_frame %frame number for analysis 
    orig_frame=read(video,i);
    crop_frame=imcrop(orig_frame,[0,0,1024,768]);
    gray_frame=rgb2gray(crop_frame);
    subtract_frame=gray_frame - background; % Subtract Background
    
    bw_frame=imbinarize(subtract_frame,thresh_level);
    bw_frame_mask = bw_frame.*mask; % Add mask
    bw2_frame=bwareaopen(bw_frame_mask, remove_Pixels,4);
    
    hsv_frame=rgb2hsv(crop_frame);
    hImage = hsv_frame(:,:,1);
	sImage = hsv_frame(:,:,2);
	vImage = hsv_frame(:,:,3);
    
    % Display original image
    subplot(3, 4, 1); 
	hRGB = imshow(crop_frame);
	% Set up an info panel so you can mouse around and inspect the value values.
	hrgbPI = impixelinfo(hRGB);
 	set(hrgbPI, 'Units', 'Normalized', 'Position',[.15 .69 .15 .02]);
	drawnow; % Make it display immediately. 
    
    % Display the hue image.
%     subplot(3, 4, 2);
    figure(2)
	h1 = imshow(hImage);
	% Set up an info panel so you can mouse around and inspect the hue values.
	hHuePI = impixelinfo(h1);
%  	set(hHuePI, 'Units', 'Normalized', 'Position',[.34 .69 .15 .02]);
  	set(hHuePI, 'Units', 'Normalized', 'Position',[.1 .05 .2 .05]);
    title('Hue Image', 'FontSize', 12);


	
	% Display the saturation image.
%     subplot(3, 4, 3);
    figure(3)
	h2 = imshow(sImage);
	title('Saturation Image', 'FontSize', 12);
	% Set up an info panel so you can mouse around and inspect the saturation values.
	hSatPI = impixelinfo(h2);
%  	set(hSatPI, 'Units', 'Normalized', 'Position',[.54 .69 .15 .02]);
  	set(hSatPI, 'Units', 'Normalized', 'Position',[.1 .05 .2 .05]);

	
	% Display the value image.
%     subplot(3, 4, 4);
    figure(4)
  	h3 = imshow(vImage);
	title('Value Image', 'FontSize', 12);
	% Set up an info panel so you can mouse around and inspect the value values.
	hValuePI = impixelinfo(h3);
%  	set(hValuePI, 'Units', 'Normalized', 'Position',[.75 .69 .15 .02]);
  	set(hValuePI, 'Units', 'Normalized', 'Position',[.1 .05 .2 .05]);


    % Now apply each color band's particular thresholds to the color band
	hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
	saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
	valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

	% Display the thresholded binary images.
    figure(1)
	fontSize = 16;
	subplot(3, 4, 6);
	imshow(hueMask, []);
	title('=   Hue Mask', 'FontSize', fontSize);
	subplot(3, 4, 7);
	imshow(saturationMask, []);
	title('&   Saturation Mask', 'FontSize', fontSize);
	subplot(3, 4, 8);
	imshow(valueMask, []);
	title('&   Value Mask', 'FontSize', fontSize);
    
	coloredObjectsMask = uint8(hueMask & saturationMask & valueMask);
	subplot(3, 4, 5);
	imshow(coloredObjectsMask, []);
	caption = sprintf('Mask of Only Regions\nof The Specified Color');
	title(caption, 'FontSize', fontSize);
	% Display the thresholded binary images.
	fontSize = 16;
	subplot(3, 4, 6);
	imshow(hueMask, []);
	title('=   Hue Mask', 'FontSize', fontSize);
	subplot(3, 4, 7);
	imshow(saturationMask, []);
	title('&   Saturation Mask', 'FontSize', fontSize);
	subplot(3, 4, 8);
	imshow(valueMask, []);
	title('&   Value Mask', 'FontSize', fontSize);
	% Combine the masks to find where all 3 are "true."
	% Then we will have the mask of only the red parts of the image.
    
	coloredObjectsMask = uint8(hueMask & saturationMask & valueMask & bw2_frame); % removed bw2_frame from inside parentheses


    subplot(3, 4, 10);
    imshow(bw2_frame,[]);
	caption = sprintf('Background Mask ');
	title(caption, 'FontSize', fontSize);
    
	% Filter out small objects.
	smallestAcceptableArea = remove_Pixels; % Keep areas only if they're bigger than this.
	% Note: bwareaopen returns a logical.
	coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, smallestAcceptableArea));
	subplot(3, 4, 9);
	imshow(coloredObjectsMask, []);
	fontSize = 13;
	caption = sprintf('bwareaopen() removed objects\nsmaller than %d pixels', smallestAcceptableArea);
	title(caption, 'FontSize', fontSize);

    bw_frame=imbinarize(hsv_frame,thresh_level);
    bw_frame_mask = bw_frame.*mask; % Add mask
    bw2_frame=bwareaopen(bw_frame_mask, remove_Pixels,4);
end

