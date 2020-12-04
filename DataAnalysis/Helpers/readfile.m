% get user-specified data analysis file and return the wet area vs time
function wet_area = readfile() 

    % TEMPORARY FIX BY VX --- ONLY PASS '_AREA.TXT' FILES IN THE FORMAT SPECIFIED BY THE NEWEST VIDEO PROCESSING CODE

    % use UI input to get the columns in the file
    % by default, interpret file as raw time, time after t0, and wet area columns

    % convert columns into column numbers to specify the time after t0 and the wet area

    [file,path] = uigetfile('*.txt'); % choose '_Area.txt' file
    fname = strcat(path,file); % gets file name from uigetfile
    fname_short = fname(1:end-4); % removes .txt or other file extension from filename

    fileID = fopen(fname, 'r'); % open file for 'r'eading
    wet_area = readmatrix(fname);
    fclose(fileID);


end
