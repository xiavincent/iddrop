%% PSEUDOCODE
% read in a video file
% select a specific point
% read each frame of the video and store the RGB values to an array
% plot each channel as a function of time



%% Track and plot video pixel RGB intensities
% Future use: track film thickness based on oscillations in a single color band

init(); % check for toolboxes, close figures

%%
[file_name,~] = getVidPath(); % get user-specified avi video file
% file_name = '/Users/Vincent/LubricinDataLocal/07_18_2020/edgeDetect/1 ugmL lubricin DS HPL2 37C 1.avi';

vid = startVid(file_name); % open Matlab video reader object
% params = getUserParams(); % get user-specified analysis parameters

point = struct; % store the location and intensity data
point.location = selectPoint(vid); % get a user-specified row,column pixel location to track
point.data = trackPoint(point.location, vid); % run through the video, read in each frame, and save the pixel's RGB intensity values as a matrix with height 3 (one for each color channel)

%% plot the data
[fig,~] = plotIntensities(point.data); % make of graph of the intensity over time
                  % REACH: output a video that highlights the point of interest in the original
                  % video, so we know what we're tracking
                  
                  
% TODO: copy the writeAnimatedPlot algorithm
                  
makeVideo(fig,point.data,point.location,file_name,vid);
                  
%% PRVIATE HELPER FUNCTIONS

function writeAnimatedPlot(file_name_short,output_framerate,area_data_output)
    % write an animated plot of the wet area data
    
    fhandle = makeBlankAreaPlot();
    
    animated_vid=VideoWriter(strcat(file_name_short,'_plot'),'MPEG-4');
    animated_vid.FrameRate = output_framerate;
    open(animated_vid);
    for entry=1:length(area_data_output) % iterate through each data point
        time = area_data_output(2,entry);
        area = area_data_output(3,entry);
        plot(time,area,'o',... % plot the graph time and the wet area 
                'MarkerSize',5,...
                'MarkerEdgeColor','b'); % marker color = blue

        writeVideo(animated_vid,getframe(gcf));
    end
    close(animated_vid); % end the video
    close(fhandle); % close the figure

end
                  


