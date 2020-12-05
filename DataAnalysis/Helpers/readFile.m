% get user-specified data analysis file and return the time and area columns
function [fname, time, area] = readFile()  

    % TEMPORARY FIX BY VX --- ONLY PASS '_AREA.TXT' FILES IN THE FORMAT SPECIFIED BY THE NEWEST VIDEO PROCESSING CODE
    % use UI input to get the columns in the file
    % by default, interpret file as raw time, time after t0, and wet area columns    
    
    [file,path] = uigetfile('*.txt'); % choose '_Area.txt' file
    fname = strcat(path,file); % gets file name from uigetfile

    fileID = fopen(fname, 'r'); % open file for 'r'eading
    area_data = readmatrix(fname); % save the numeric data
    fclose(fileID); % close the file after reading
    
    [time, area] = extractCols(area_data); % get the time and area from the file based on user input
    
end

function [time, area] = extractCols(area_data)

    prompt = {'In which column is the time? (e.g., 2)', 'In which column is the wet area? (e.g., 3)'};
    dlgtitle = 'Area data file import';
    dims = [1 35];
    default = {'2','3'}; % set columns 2 and 3 as the default time and area data columns
    
    import = inputdlg(prompt,dlgtitle,dims,default); 
    time_col = str2double(import{1});
    area_col = str2double(import{2});
      
    time = area_data(:,time_col); % grab correct columns from the input 
    area = area_data(:,area_col);

end
