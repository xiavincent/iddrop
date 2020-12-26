%% FUNCTION
% Initialize and start the output videos
% OUTPUT: a struct containing video writer objects of all initialized videos
function [videos] = initVids(file_name_short, output_framerate, output_yn)
    bw = 0; % video writer objects to be filled in as needed
    analyzed_frames = 0;
    all_masks = 0;
    falsecolor = 0;

    if (~output_yn.bw_mask)
        bw=VideoWriter(strcat(file_name_short,'_maskVideo'),'MPEG-4'); %writes black/white video showing wet area (black) vs. dry area (white)
        bw.FrameRate = output_framerate; %sets output video frame rate
        open(bw); % opens output video for writing
    end
    
    if (~output_yn.analyzed) 
        analyzed_frames = VideoWriter(strcat(file_name_short,'_analyzedOrigVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
        analyzed_frames.FrameRate = output_framerate; %sets output video frame rate
        open(analyzed_frames); % opens video for analyzed frames from original video
    end
    if (~output_yn.masks)
        all_masks = VideoWriter(strcat(file_name_short,'_allMasks'),'MPEG-4'); %writes video showing the original frames that were analyzed
        all_masks.FrameRate = output_framerate; %sets output video frame rate
        open(all_masks); % opens video for displaying individual masks
    end
    if (~output_yn.falsecolor)
        falsecolor = VideoWriter(strcat(file_name_short,'_falseColor'),'MPEG-4'); %writes falsecolor video showing wet area (green) and analyzed dry area (red)
        falsecolor.FrameRate = output_framerate; %sets output video frame rate
        open(falsecolor); % opens false color overlay video
    end
    
    videos.bw = bw;
    videos.analyzed = analyzed_frames;
    videos.masks = all_masks;
    videos.falsecolor = falsecolor;
end

