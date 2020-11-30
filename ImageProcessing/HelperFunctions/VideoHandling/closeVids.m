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