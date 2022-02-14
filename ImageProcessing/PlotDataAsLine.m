% Plot wet area as a function of time for two data matrices
% An alternate method is to write this function using variadic inputs

file_name1 = '/Volumes/Extreme SSD/HonorsThesis/HonorsThesisIddropData/08-22-2021-0percent/HPL1-PBS-24uL-1mM-0percentDPPC-soln-37C-LongerTrough-TRIAL2_Area.txt'; % the file path for the txt file to be read
file_name_short1 = file_name1(1:end-4); % removes .txt from file name
area_data1 = readmatrix(file_name1); % read the data from the outputted txt file
area_data1 = transpose(area_data1); % transpose the data to put it in the format required for the plotting function

file_name2 = '/Volumes/Extreme SSD/HonorsThesis/HonorsThesisIddropData/08-26-2021-100percent/HPL1-PBS-24uL-1mM-100percentDPPC-soln-37C-LongerTrough-TRIAL3_Area.txt';
file_name_short2 = file_name2(1:end-4); % removes .txt from file name
area_data2 = readmatrix(file_name2); % read the data from the outputted txt file
area_data2 = transpose(area_data2); % transpose the data to put it in the format required for the plotting function

plotAreaLine(area_data1,area_data2,file_name_short1) % plot the data and save a graph

function plotAreaLine(area_data1,area_data2,file_name_short) % similar function as 'plotArea.m', but plots the data as a line instead of as a scatter plot
    
    fhandle = makeBlankAreaPlot(); %generate blank plot
    time1 = area_data1(2,:);
    area1 = area_data1(3,:);

    time2 = area_data2(2,:);
    area2 = area_data2(3,:);

    plot(time1,area1,'Color','blue','LineWidth',2); % plot the first data series
    plot(time2,area2,'Color','red','LineWidth',2); % plot the first data series

    ylim([0,1])

    legend('Pure SS','Pure DPPC')

    print(fhandle,strcat(file_name_short,'_LineGraph.pdf'),'-dpdf'); % save graph to pdf
    print(fhandle,strcat(file_name_short,'_LineGraph.tif'),'-dtiff'); % save graph to png

end