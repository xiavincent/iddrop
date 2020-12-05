%% DATA PROCESSING OF DEWETTING FROM TEXT FILE

% Takes a txt file of wet area vs time as an input and calculates the dewetting onset time
% TODO: returns a txt file of smoothed wet area vs time

% Kiara Cui, Vincent Xia
% Nov 2020
%%

startup(); % add subfolders to path
[fname, time, area] = readFile();  % retrieve data from .txt file
plotRaw(time,area); % plot raw data 

params = getParams(); % dialog box to determine how to process data

%% Find Dewetting Onset Time

if (params.smooth == 0)  % smooth data if requested by user
    area = smoothData(params.smooth_window,area);
end

getDOT(params); % TODO: find and plot the DOT. Loop if user not satisfied

saveParams(); % save parameters
