%% FUNCTION
% Save the RGB intensity vs time of the pixel location 
function output = trackPoint(loc, vid)

    start_frame = 100;
    skip_frame = 100;
    num_it = floor((vid.NumFrames-start_frame)/skip_frame + 1);
    
    output = struct; % struct to store RGB intensities and time output
    output.RGB = zeros(3,num_it); % initialize RGB output matrix
    output.time = zeros(1,num_it); % initialize time matrix

    for i=start_frame:skip_frame:vid.NumFrames % read every 100 frames
        index = (i-start_frame)/skip_frame + 1; % index number for data storage
        cur_frame = read(vid,i); % read in the frame
        output.RGB(:,index) = cur_frame(loc(1),loc(2),:); % grab the RGB value at the pixel location
        output.time(1,index) = i/vid.FrameRate; % calculate the raw video time
    end
   
    
end