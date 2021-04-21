%% FUNCTION
% Write overlain images into an mp4 video that has already been initialized
function writeOverlayVid(overlay,wet_frac,skip_frame,first_fnum,output_yn,video)
   if (output_yn)
        for i=1:length(overlay) % write every overlay frame
            fnum = (i-1)*skip_frame + first_fnum;
            writeOverlayFrame(overlay{i},fnum,wet_frac(i),video); % write overlay frames to mp4 video
        end
   end
end

function writeOverlayFrame(overlay,frame_num,wet_frac,video)
    frame_info = sprintf('Frame: %d |  Area: %.3f', frame_num, wet_frac); % prints frame # and area frac for each mp4 video frame
    output_img = insertText(overlay,[100 50],frame_info,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox
    writeVideo(video, output_img); % writes video with analyzed frames
end