%% FUNCTION
% Allow a user to select a specific point on the tear film to track over time
function coord = selectPoint(vid)
    fnum = 2000; % frame number to display when user selects their point
    frame = read(vid,fnum);
    
    figure; % display as original image size
    title('Select point of interest')
    imshow(frame)
    truesize([768 1024]);
    [x,y] = getpts; % interactive point selection || press return to exit
    close;
        
    row = round(y);
    col = round(x);
    coord = [row col];
end