%% DATA PROCESSING OF DEWETTING FROM TEXT FILE

% Takes a txt file of wet area vs time as an input and calculates the dewetting onset time
% TODO: outputs a txt file of smoothed wet area vs time

% Kiara Cui, Vincent Xia
% Nov 2020
%%

init(); % add subfolders to path
[fname, time, area] = readFile(); % retrieve data from .txt file
plotRaw(fname,time,area); % plot raw data for user to see
params = getParams(); % dialog box to determine how to process data

%% Find Dewetting Onset Time

if (params.smooth == 0)  % smooth data if requested by user
    area = smoothData(params.smooth_window,area);
end

[result, params] = getDOT(fname, params, time, area); % get bounds, find the DOT, repeat if not satisfied

saveParams(fname,params,result); % save parameters
