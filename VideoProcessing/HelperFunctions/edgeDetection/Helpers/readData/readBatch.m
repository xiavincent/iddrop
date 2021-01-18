% read all the images in a folder_path

function frames = readBatch(folder_path)
    files = dir(folder_path);
    
    frames = cell([1 length(files)]);
    for i=1:length(files) % read files into a cell array of structs
        base_name = files(i).name;
        fname = fullfile(files(i).folder,base_name);
        [frames{i}.frame,~,~] = readFrame(fname);
        frames{i}.num = str2double(base_name(end-7:end-4)); % grab the last 4 digits
    end
end