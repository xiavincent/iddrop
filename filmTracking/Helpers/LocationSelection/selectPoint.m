%% FUNCTION
% Allow a user to select a specific point on the tear film to track over time
function coord = selectPoint(vid)
    fnum = 2000; % frame number to display when user selects their point
    frame = read(vid,fnum);
    
    figure
    title('Select point of interest')
    imshow(frame)
    [x,y] = getpts; % interactive point selection || press return to exit
    
    row = y;
    col = x;
    coord = [row col];
end