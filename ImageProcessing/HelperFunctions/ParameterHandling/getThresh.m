% get thresholding parameters based on input dialog of thresholding values
function [H_thresh_low, H_thresh_high, S_thresh_low, S_thresh_high, V_thresh_low, V_thresh_high] = getThresh(threshold_values)
    H_thresh_low = str2double(threshold_values{1});
    H_thresh_high = str2double(threshold_values{2});
    S_thresh_low = str2double(threshold_values{3});
    S_thresh_high = str2double(threshold_values{4});
    V_thresh_low = str2double(threshold_values{5});
    V_thresh_high = str2double(threshold_values{6});
end