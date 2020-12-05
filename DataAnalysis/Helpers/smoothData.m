% smooth data 
function area = smoothData(smooth_window, area)
        area = movmean(area, smooth_window); % moving mean value 
end