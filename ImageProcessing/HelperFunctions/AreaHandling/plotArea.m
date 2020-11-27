function plotArea(area_data_output,file_name_short)
    % plot the wet area as a function of time
    
    makeBlankAreaPlot(); %generate blank plot
    time = area_data_output(2,:);
    area = area_data_output(3,:);
    plot(time,area,'.',...
        'MarkerSize',5); % plot our data
    print('-dtiff',strcat(file_name_short,'_graph.tiff')); % save to tiff file

end