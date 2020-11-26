%% IMAGE PROCESSING OF DEWETTING FROM VIDEO 
% Takes a ".avi" video file, creates a plot of normalized area vs time. Saves 
% an "_Area.txt" file that stores the analyzed data and can be passed into the 
% "dataprocessing" file for further processing and analysis.

% NOTE: this program requires Matlab "image processing toolbox" to run on Matlab 2020a/b

% Last tested: August 2020
% Version: Matlab 2020ab                    

% November 2020
% Vincent Xia

%TODO: fix edge algorithm
%% Clear everything

close all hidden;
clc;
%% Input dialogs
% Analysis settings:

[file,path] = uigetfile('*.avi'); %choose .avi file (can change format if needed)
file_name = strcat(path,file); % gets file name from uigetfile

analysis_settings = inputdlg({'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Select video frame for area analysis'},'Sample',...  % Frame for defining total area; pick frame after edge 'gravity-driven' dewetting occurs, and once interference patterns begin                                                            
                                [1 50; 1 20;1 20;1 20],{'250','3','40','2500'});
%% 
% Analysis types:                                 

analysis_type = inputdlg({'New or old software?(1=New,0=Old)',... % Old uEye Cockpit laptop software or New Thorcam software from 2/25/2020 onwards
                          'Lubricin or Water?(1=lubricin, 0=water)',... % Which sample are you measuring dewetting on?
                          'Circle or freehand area fit? (1=circle, 0=freehand)'},... % the area selection method for defining total area
                          'Analysis Type', [1 40; 1 40; 1 40], {'1','1','1'});                                 
%% 
% Video output types:

video_output_types = inputdlg({ 'Falsecolor final output? (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                          'Output analyzed frames?(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                          'Output individual masks video?(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                          'Output black/white mask?(1=no,0=yes)',... % binary version of final mask
                          'Output animated plot? (1=no, 0=yes)'},... % animated video of the dewetting plot
                          'Output video types (note: choosing yes on any of these will be slower)', [1 40; 1 40; 1 40; 1 40; 1 40], {'1','1','1','1','1'});
%% Parameters for image processing
% Initialize our parameters from the dialog boxes:

[remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num,...
    sftwre_type,liquid_type,area_fit_type,...
    output_false_color,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] = fill_params(analysis_settings,analysis_type,video_output_types); %fill in all the parameters from the dialog boxes using helper function
%% 
% Theshold values for hue, saturation, value analysis (use Threshold Check or 
% Matlab "Color Thresholder" App to test values)

if sftwre_type == 0  %Old uEye Cockpit software
    if liquid_type == 1 %DI water
        % Used "DIWater HPL3 RT2" file from 2-21-2020, frame 1000 to obtain
        % threshold values  
        H_thresh_low = 0;
        H_thresh_high = 1;
        S_thresh_low = 0;
        S_thresh_high = 1;
        V_thresh_low = 0.7;
        V_thresh_high = 1;   
    elseif liquid_type == 0 %lubricin    
        %Used ".5 ugml lubricin DS HPL 2 37C 1" from 1-20-2020,frame 2085
        %to obtain threshold values
        H_thresh_low = .4;
        H_thresh_high = .5;
        S_thresh_low = .3;
        S_thresh_high = .4;
        V_thresh_low = 0.7;
        V_thresh_high = 1;
    end
elseif sftwre_type == 1 %New Thorcam software
    if liquid_type == 0 %DI Water

        % From 07-05-20 HPL3 DIWater Test 2 file
        H_thresh_low = 0;
        H_thresh_high = 1;
        S_thresh_low = 0;
        S_thresh_high = 1;
        V_thresh_low = 0.659;
        V_thresh_high = 1;
        
    elseif liquid_type == 1 %lubricin
        
  %      For 08-12-20 1 ugmL HPL3 RT solvent trap
%         hueThresholdLow = .438;
%         hueThresholdHigh = .535;
%         saturationThresholdLow = .177;
%         saturationThresholdHigh = .236;
%         valueThresholdLow = .718;
%         valueThresholdHigh = .906;

        
    % For 07-19-20 .5 ugmL HPL1 NR (less discriminatory)
%         hueThresholdLow = .410;
%         hueThresholdHigh = .554;
%         saturationThresholdLow = .104;
%         saturationThresholdHigh = .271;
%         valueThresholdLow = .439;
%         valueThresholdHigh = .780;
        
        
        % For 10-13-20 1 ugmL lubricin TS HPL4 37C
        H_thresh_low = .422;
        H_thresh_high = .500;
        S_thresh_low = .104; %.164 <--- saturation boundaries have a substantial impact on video thresholding!
        S_thresh_high = .271; %.233
        V_thresh_low = .490; %.490
        V_thresh_high = .761; %.761
    end 
end

%% Video Import

crop_start = [150,50]; % upper left hand corner for cropping rectangle
crop_size = [700,700]; % crop size
crop_rect = [crop_start, crop_size-1]; % cropping rectangle || subtract one to make it exactly 700 by 700 in size

video = VideoReader(file_name); % starts reading video
file_name_short = file_name(1:end-4); % removes .avi or other file extension from filename
num_frames = video.NumFrames; % gets # of frames in video
input_fps = video.FrameRate; % gets frames/second in initial video
% TODO: add support for video height/width

background_frame = read(video, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
background_frame_cropped = imcrop(rgb2gray(background_frame),crop_rect); % Converts to grayscale and crops size                                                                              
%% Set total area

area_frame        = read(video,area_frame_num);             % Read user specified frame for area analysis
area_frame_cropped = imcrop(area_frame,crop_rect);     % Crop area frame

[area_mask, outer_region, max_area, shadow_mask, camera_area] = userdrawROI(area_frame_cropped,area_fit_type); %helper function to handle our ROI drawing
%% Analyze video

% Define output video parameters; open videos for writing
output_framerate = 20; %output frame rate
[bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(output_black_white_mask, file_name_short, output_framerate, output_analyzed_frames, output_all_masks, output_false_color);

% Begin video processing
wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...');
num_it = floor(num_frames/skip_frame); % number of times we iterate through the analysis loop

dewet_area = zeros(1,num_it*skip_frame); % stores the area for every frame index (formerly called 'grain_areas')
wet_area = zeros(size(dewet_area)); % stores normalized wet area for every frame index

final_frame_num = 3000; % dictates the last frame of the video to be analyzed
for cur_frame_num = t0_frame_num: skip_frame: final_frame_num
    waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
    orig_frame = read(video,cur_frame_num); % reading individual frames from input video
    crop_frame = imcrop(orig_frame,crop_rect); 
    gray_frame = rgb2gray(crop_frame); % grayscale frame from video
    subtract_frame = gray_frame - background_frame_cropped; % Subtract background frame from current frame
    
% Masking and binarization: 
    subtract_frame(shadow_mask) = 0; % apply the camera mask
    subtract_frame(~area_mask) = 0; % apply area mask
    bw_frame_mask=imbinarize(subtract_frame);

% HSV Masking
    hsv_frame = rgb2hsv(crop_frame); % convert to hsv image
    
    % Apply each color band's particular thresholds to the color band
	hue_mask = (hsv_frame(:,:,1) >= H_thresh_low) & (hsv_frame(:,:,1) <= H_thresh_high); %makes mask of the hue image within theshold values
	sat_mask = (hsv_frame(:,:,2) >= S_thresh_low) & (hsv_frame(:,:,2) <= S_thresh_high); %makes mask of the saturation image within theshold values
	val_mask = (hsv_frame(:,:,3) >= V_thresh_low) & (hsv_frame(:,:,3) <= V_thresh_high); %makes mask of the value image within theshold values
    HSV_mask = hue_mask & sat_mask & val_mask; % defines area that fits within hue mask, saturation mask, and value mask    
    
    combined_mask = HSV_mask & bw_frame_mask; % apply binarization mask
    combined_mask(shadow_mask) = 0; % apply camera mask
    combined_mask(~area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, remove_Pixels); % remove small components

% Count Area; use *Edge Algorithm 2* to throw away inside regions
    [label_dewet_img, dewet_area(cur_frame_num)] = countArea(combined_mask_open,outer_region,size(gray_frame),area_fit_type);       
 
% Write final videos  
        % TODO: don't convert to label matrix!
        
        wet_area(cur_frame_num) = writeOutputVids(output_false_color,output_analyzed_frames,output_all_masks,output_black_white_mask,...
                                                          gray_frame,crop_frame,orig_frame,HSV_mask,HSV_mask_rm_obj,bw_frame_mask_clean,label_dewet_img,...
                                                          bw_vid,false_color_vid,analyzed_frames_vid,all_masks_vid,...
                                                          dewet_area(cur_frame_num),...
                                                          t0_frame_num,cur_frame_num,...
                                                          max_area,camera_area,...
                                                          input_fps);
    
end

closeVids(output_black_white_mask, bw_vid, output_analyzed_frames, analyzed_frames_vid, output_all_masks, all_masks_vid, output_false_color, false_color_vid);
close(wait_bar); %closes wait bar
%% Generate time vs area; plot data; write animated video

%Create time array
time = zeros(1,length(wet_area)); % initialize time
graph_time = zeros(1,length(wet_area)); % time after t0
output_size = floor(final_frame_num/skip_frame); % number of row entries for the final area+time file output
area_data_output = zeros(3,output_size); % 2D matrix storing the corresponding area+time output

if(~output_animated_plot) % initialize video of animated plot
    animated_vid=VideoWriter(strcat(file_name_short,'_plot'),'MPEG-4');
    animated_vid.FrameRate = output_framerate;
    open(animated_vid);
end

figure('Name','Area Plot'   );
hold on;
formatAreaPlot(); % Create and format area plot

for cur_frame_num = t0_frame_num:skip_frame:final_frame_num
    time(cur_frame_num)=cur_frame_num/input_fps; %adjusts time for skipped frames and initial frame rate
    graph_time(cur_frame_num) = time(cur_frame_num) - t0_frame_num/input_fps;
    entry_num = (cur_frame_num-t0_frame_num)/skip_frame + 1; % row entry number for the data output file
    area_data_output(:,entry_num) = [time(cur_frame_num);  graph_time(cur_frame_num) ; wet_area(cur_frame_num)];
    
    if(~output_animated_plot) % writes video of animated plot for each 
        plot(time(cur_frame_num),wet_area(cur_frame_num),'o');
        writeVideo(animated_vid,getframe(gcf));
    end
end

if(~output_animated_plot)
   close(animated_vid);
end

plot(time,wet_area,'o'); % generate plot
print('-dtiff',strcat(file_name_short,'_graph.tiff')); %save to tiff file
%% Store analyzed data into text file to be used with image processing code

file_id=fopen(strcat(file_name_short,'_Area.txt'),'w');
fprintf(file_id,'%20s %20s %20s \n','Raw time (s)', 'time after t0 (s)', 'area'); 
fprintf(file_id, '%20.3f %20.3f %20.3f \n', area_data_output);
fclose(file_id);
%% Store all data (including skipped frames) into text file

file_id=fopen(strcat(file_name_short,'_AllData.txt'),'w');
fprintf(file_id, '%d %d \n', [time wet_area]');
fclose(file_id);
%% Store image processing parameters into text file

file_id=fopen(strcat(file_name_short,'_Parameters.txt'),'w'); %saves parameters used in file for analysis 
fprintf(file_id, 'remove_Pixels = %d \n', remove_Pixels);
fprintf(file_id, 't_0 = %d \n', t0_frame_num);
fprintf(file_id, 'background = %d \n', background_frame_num);
fprintf(file_id, 'frame for area analysis = %d \n', area_frame_num);
fprintf(file_id, 'frames_skipped = %d \n', skip_frame);
fprintf(file_id, 'HueThreshold = (%.3f,%.3f) \n', H_thresh_low, H_thresh_high);
fprintf(file_id, 'SaturationThreshold = (%.3f,%.3f) \n', S_thresh_low, S_thresh_high);
fprintf(file_id, 'ValueThreshold = (%.3f,%.3f)', V_thresh_low, V_thresh_high);
fclose(file_id);
%% 
%% Helper functions
% 
% 
% Circle specific custom wait function

% function [center, radius] = customWaitCircle(hROI)
%     l = addlistener(hROI,'ROIClicked',@clickCallback);  % Listen for mouse clicks on the ROI
%     
%     uiwait; % Block program execution
%     
%     delete(l); % Remove listener
%     
%     % Return the circle's center and radius
%     center = hROI.Center;
%     radius = hROI.Radius;
% end
%% 
% 
% 
% *Write videos*
% 
% writes the output videos for a given frame based on user-specified output 
% types

function [wet_area] = writeOutputVids(outputFalseColor,outputAnalyze,outputMasks,output_black_white_mask,...
                              gray_frame,crop_frame,orig_frame,HSV_mask,HSV_mask_rmv_obj,bw_frame_mask_clean,label_dewet_img, ...
                              output_vid,falseColorVideo,analyzedVideo,allMasksVideo, ...
                              dewet_area,...
                              t0_frame_num,cur_frame_num,...
                              max_area,camera_area,...
                              input_fps)

                        
        vid_time = cur_frame_num/input_fps; % raw video time
        graph_time = vid_time - t0_frame_num/input_fps; % adjusts time for skipped frames and initial frame rate  
        wet_area = 1-(dewet_area./(max_area-camera_area)); % normalize dry area based on total area minus camera shadow area. subtract from 1 to get total wet area            

        frame_info = sprintf('Frame: %d | Video time: %.3f sec | Graph time: %.3f sec | Area: %.3f', cur_frame_num, vid_time, graph_time, wet_area); % prints frame #, time stamp, and area for each mp4 video frame

%% 
% Output black & white mask video:

        if (~output_black_white_mask) % make a movie of the black/white final mask frames       
            final_mask = label_dewet_img > 0;
            output_text = insertText(final_mask,[100 50],frame_info,'AnchorPoint','LeftBottom'); % requires Matlab Computer Vision Toolbox            
            writeVideo(output_vid,output_text); % writes video with analyzed frames  
        end
%% 
% Output falsecolor:        

        if (~outputFalseColor)  % make a falsecolor overlay of our final mask over the original grayscale image 
            FinalImgFuse = labeloverlay(gray_frame,label_dewet_img);
%             FinalImgFuse = imfuse(finalMask,gray_frame,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); %create falsecolor overlay of binary mask over original image    
            falseColorInfo = sprintf('red = binary mask | green = original img | yellow = both'); % prints false color info                
            output_text = insertText(FinalImgFuse,[100 50],frame_info,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox
            output_text = insertText(output_text,[100 100],falseColorInfo,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox    
            writeVideo(falseColorVideo,output_text); %writes video with analyzed frames
        end        
%% 
% Output analyzed frames:

        if (~outputAnalyze) 
            frame_info = sprintf('Frame: %d | Time: %.3f sec ', cur_frame_num , graph_time); % prints frame #, time stamp, and area for each mp4 frame
            image = insertText(orig_frame,[30 725],frame_info,'FontSize',55,'BoxColor','white','AnchorPoint','LeftBottom'); %requires Matlab Computer Vision Toolbox
            writeVideo(analyzedVideo,image);
        end
%% 
% Output individual masks:       

        if(~outputMasks) 
            box_color = 'green';
           
            im0 = insertText(crop_frame,[100 50],"orig image",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            im1 = insertText(im2uint8(HSV_mask),[100 50],"HSV mask",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
                fuse = imfuse(im2uint8(HSV_mask),im2uint8(bw_frame_mask_clean),'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); %create falsecolor overlay of area mask with HSV mask
            im2 = insertText(fuse, [100 50],'HSV w/ binarize overlay','FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            im3 = insertText(im2uint8(bw_frame_mask_clean),[100 50],"Binarize mask (contains area mask)",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');            
            im6 = insertText(label_dewet_img,[100 50],'final mask','FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            
            im7 = insertText(im2uint8(HSV_mask_rmv_obj),[100 50],"HSV mask after removing small objects and small mask holes",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            
%           blank = zeros(size(im0)); use this to fill in gaps of the montage if there's not enough videos to output
            concat1 = cat(1,im0,im1,im2); %concatenate the images together
            concat2 = cat(1,im3,im6,im7);
            concatFinal = cat(2,concat1,concat2);
            
            finalImage = insertText(concatFinal,[300 50],frame_info,'FontSize',20,'AnchorPoint','LeftBottom'); %requires Matlab Computer Vision Toolbox
            writeVideo(allMasksVideo,finalImage);
        end     
end

        
%% 
% 
% 
% Formatting specs for area plot:

function formatAreaPlot() 
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial');
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName'   , 'Arial');
    set(gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;
end

%% 
% 
% 
% Initializing and open output videos

function [bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(output_black_white_mask, file_name_short, output_framerate, output_analyzed_frames, output_all_masks, output_false_color)
    bw_vid = 0; %initialize videos
    analyzed_frames_vid = 0;
    all_masks_vid = 0;
    false_color_vid = 0;

    if (~output_black_white_mask)
        bw_vid=VideoWriter(strcat(file_name_short,'_maskVideo'),'MPEG-4'); %writes black/white video showing wet area (black) vs. dry area (white)
        bw_vid.FrameRate = output_framerate; %sets output video frame rate
        open(bw_vid); % opens output video for writing
    end
    
    if (~output_analyzed_frames) 
        analyzed_frames_vid = VideoWriter(strcat(file_name_short,'_analyzedOrigVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
        analyzed_frames_vid.FrameRate = output_framerate; %sets output video frame rate
        open(analyzed_frames_vid); % opens video for analyzed frames from original video
    end
    if (~output_all_masks)
        all_masks_vid = VideoWriter(strcat(file_name_short,'_allMasks'),'MPEG-4'); %writes video showing the original frames that were analyzed
        all_masks_vid.FrameRate = output_framerate; %sets output video frame rate
        open(all_masks_vid); % opens video for displaying individual masks
    end
    if (~output_false_color)
        false_color_vid = VideoWriter(strcat(file_name_short,'_falseColor'),'MPEG-4'); %writes falsecolor video showing wet area (green) and analyzed dry area (red)
        false_color_vid.FrameRate = output_framerate; %sets output video frame rate
        open(false_color_vid); % opens false color overlay video
    end
end

%% 
% Close output videos


function closeVids(output_black_white_mask, bw_vid, output_analyzed_frames, analyzed_frames_vid, output_all_masks, all_masks_vid, output_false_color, false_color_vid)
    if (~output_black_white_mask)
        close(bw_vid); %close videowriter for binary mask
    end
    if (~output_analyzed_frames)
        close(analyzed_frames_vid); %close analyzed frames video
    end
    if(~output_all_masks)
        close(all_masks_vid); %close individual masks video
    end
    if (~output_false_color)
        close(false_color_vid); %close falsecolor video
    end
end
%% 
% 
% 
%