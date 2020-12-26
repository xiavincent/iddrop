% Initialize and start the output videos
function [bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(file_name_short, output_framerate, output_yn)
    bw_vid = 0; %initialize videos
    analyzed_frames_vid = 0;
    all_masks_vid = 0;
    false_color_vid = 0;

    if (~output_yn.bw_mask)
        bw_vid=VideoWriter(strcat(file_name_short,'_maskVideo'),'MPEG-4'); %writes black/white video showing wet area (black) vs. dry area (white)
        bw_vid.FrameRate = output_framerate; %sets output video frame rate
        open(bw_vid); % opens output video for writing
    end
    
    if (~output_yn.analyzed) 
        analyzed_frames_vid = VideoWriter(strcat(file_name_short,'_analyzedOrigVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
        analyzed_frames_vid.FrameRate = output_framerate; %sets output video frame rate
        open(analyzed_frames_vid); % opens video for analyzed frames from original video
    end
    if (~output_yn.masks)
        all_masks_vid = VideoWriter(strcat(file_name_short,'_allMasks'),'MPEG-4'); %writes video showing the original frames that were analyzed
        all_masks_vid.FrameRate = output_framerate; %sets output video frame rate
        open(all_masks_vid); % opens video for displaying individual masks
    end
    if (~output_yn.falsecolor)
        false_color_vid = VideoWriter(strcat(file_name_short,'_falseColor'),'MPEG-4'); %writes falsecolor video showing wet area (green) and analyzed dry area (red)
        false_color_vid.FrameRate = output_framerate; %sets output video frame rate
        open(false_color_vid); % opens false color overlay video
    end
end

