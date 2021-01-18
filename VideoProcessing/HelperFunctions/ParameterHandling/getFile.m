% Return a user specified file name and the file name without the extension (e.g., '.avi')
function [file_name,file_name_short] = untitled(inputArg1,inputArg2)
    [file,file_path] = uigetfile('*.avi'); %choose .avi file (can change format if needed)
    file_name = strcat(file_path,file); % gets file name from uigetfile
    file_name_short = file_name(1:end-4); % removes .avi or other file extension from filename
end

