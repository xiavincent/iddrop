% grab the specified frames from the original video and put them into a new output video
function saveFrames(input_vid,output_vid,params)
    end_time = getEndTime(params.shorten,params.t0,input_vid);
        
    fnum = params.t0;
    time = 0;
    while (time <= end_time)
        frame = read(input_vid,fnum); % grab the frame
        writeToOutput(frame,time,output_vid); % write it to the output video
        fnum = fnum + params.skip; % increment frame number
        time = time + params.skip/round(input_vid.FrameRate); % increment the time
    end
end


%% PRIVATE HELPER FUNCTIONS

% evaluate final time stamp based on binary input parameter, which indicates whether or not to
% shorten the video
function end_time = getEndTime(shorten,t0_fnum,input_vid)
    if (shorten)
        end_time = 1800; % 30 min mark
    else
        end_time = (input_vid.NumFrames - t0_fnum)/input_vid.FrameRate; % end of video
    end
end



% write a frame to the output video with its accompanying caption
function writeToOutput(frame,time,output_vid)
%     time = (fnum - t0_fnum)/output_vid.FrameRate; % get the time in sec's after the first frame
    time_stamp = sprintf('%.3f sec ',time); % prints the time stamp for each mp4 frame
    image = insertText(frame,[20 750],time_stamp,'FontSize',45,'BoxColor','white','AnchorPoint','LeftBottom');
            % paste the time stamp onto the image in the bottom left hand corner
    writeVideo(output_vid,image);
end
