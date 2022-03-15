% Plot wet area as a function of time for data matrices
% Uses variadic inputs to plot as many data sets as desired. If plotting more
    % than one data set, simply input the data matrices and file names in
    % sequential order

function PlotDataAsLine(area_data_array,file_name_short) % Input the data matrices in a 1xN cell array, followed by the desired output file name without extension. 

    % optional usage for reading in data that has already been saved
    % file_name1 = '/Volumes/Extreme SSD/HonorsThesis/HonorsThesisIddropData/08-22-2021-0percent/HPL1-PBS-24uL-1mM-0percentDPPC-soln-37C-LongerTrough-TRIAL2_Area.txt'; % the file path for the txt file to be read
    % file_name_short1 = file_name1(1:end-4); % removes .txt from file name
    % area_data1 = readmatrix(file_name1); % read the data from the outputted txt file
    % area_data1 = transpose(area_data1); % transpose the data to put it in the format required for the plotting function
    
    plotAreaLine(area_data_array,file_name_short) % plot the data and save a graph

end
%% PRIVATE HELPER FUNCTIONS


function plotAreaLine(area_data_array,file_name_short) % similar function as 'plotArea.m', but plots the data as a line instead of as a scatter plot
 
    fhandle = makeBlankAreaPlot(); % generate blank plot
    len = size(area_data_array); % get the number of data array inputs

    for i=1:len % iterate through each dataset
        time = area_data_array{i}(2,:);
        area = area_data_array{i}(3,:);
        plot(time,area,'LineWidth',2); % plot each data series
    end
   
    ylim([0,1])

%     legend('Pure SS','Pure DPPC') % change legend as desired

    print(fhandle,strcat(file_name_short,'_LineGraph.pdf'),'-dpdf'); % save graph to pdf
    print(fhandle,strcat(file_name_short,'_LineGraph.tif'),'-dtiff'); % save graph to png

end