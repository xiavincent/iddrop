% read a single image frame from a character vector of the file name
% return the RGB, HSV, and grayscale intensity versions of the image
function [RGB,HSV,grayscale] = readFrame(file_name)
    RGB = imread(file_name);
    HSV = rgb2hsv(RGB);
    grayscale = rgb2gray(RGB);
end