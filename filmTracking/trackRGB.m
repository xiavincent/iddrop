
%% PSEUDOCODE
% read in a video file
% select a specific point
% read each frame of the video and store the RGB values to an array
% plot each channel as a function of time



%% Track and plot video pixel RGB intensities
% Future use: track film thickness based on oscillations in a single color band

init(); % check for toolboxes, close figures
getVidPath(); % get user-specified avi video file

point.location = selectPoint(); % get a user-specified row,column pixel location to track

point.intensity = trackPoint(); % run through the video, read in each frame, and save the pixel's RGB intensity values as a matrix with height 3 (one for each color channel)

plotPoint(point); % make of graph of the intensity over time
                  % REACH: output a video that highlights the point of interest in the original
                  % video, so we know what we're tracking