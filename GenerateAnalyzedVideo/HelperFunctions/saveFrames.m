% grab the specified frames from the original video and put them into a new output video
function saveFrames(input_vid,output_vid,params)
    final_fnum = getFinalFrameNum(params.shorten,params.t0,input_vid.FrameRate);

%     for i=params.t0:params.skip:final_fnum % iterate through the video
        
    fnum = params.t0;
    time = 0;
    while (time <= 600)
        frame = read(input_vid,fnum); % grab the frame
        writeToOutput(frame,time,output_vid); % write it to the output video
        fnum = fnum + params.skip; % increment frame number
        time = time + params.skip/round(input_vid.FrameRate); % increment the time
    end
end


%% PRIVATE HELPER FUNCTIONS

% evaluate final frame number based on binary input parameter indicating whether or not to
% shorten the video
function final_fnum = getFinalFrameNum(shorten,t0_fnum,framerate) 
    if (shorten) 
        final_fnum = t0_fnum + 600*framerate; % final frame number based on 10 min mark
    else 
        final_fnum = input_vid.NumberOfFrames;
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
