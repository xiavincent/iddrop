%% DATA PROCESSING OF DEWETTING FROM TEXT FILE

% Takes a txt file of wet area vs time as an input and calculates the dewetting onset time
% TODO: returns a txt file of smoothed wet area vs time

% March 29, 2020
% Kiara Cui and Vincent Xia, Nov 2020
%% Clear everything

% clear variables global;
% close all hidden;
% clc;
% warning('off','all'); %Suppress warnings for faster exec.

%% Retrieve area data from .txt file and plot raw data

[file,path] = uigetfile('*.txt'); %choose '_Area.txt' file
fname = strcat(path,file); % gets file name from uigetfile
fileID = fopen(fname, 'r');
fname_short = fname(1:end-4); %removes .txt or other file extension from filename

% formatSpec = '%e'; % data are in exponential notation format

Area = fscanf(fileID, [2 Inf]);
timedata = Area(1,:);
areadata = Area(2,:);

%Figure formatting
figure, hold on 
xlim([0 600]);
ylim([0 1.2]);
xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial')
ylabel('Wet Area / Total Area','FontSize' , 20,'FontName'   , 'Arial')
set(gca,'FontName', 'Arial','FontSize',18);
set(gcf, 'PaperPositionMode', 'auto');
box on;

plot(timedata,areadata,'o');
print('-depsc2',strcat(fname,'_graph.eps'));
print('-dtiff',strcat(fname,'_graph.tiff'));
%% Dialog box to determine how to process data

data_processing = inputdlg({'Does the video dewet? (0=no, 1=yes)','Select upper bound of region to fit',...
    'Select lower bound of region to fit','Perform smoothing? (0=no, 1=yes)','Smoothing window width'},...
    'Data Processing', [1 20; 1 20;1 20;1 20;1 20],{'1','0.97','0.8','1','5'});

dewet_or_not = str2double(data_processing{1}); %gets this from input dialog
upperbound = str2double(data_processing{2}); %gets this from input dialog
lowerbound = str2double(data_processing{3}); %gets this from input dialog
smooth_or_not = str2double(data_processing{4});   % gets this from input dialog
smooth_window = str2double(data_processing{5}); %gets this from input dialog
%% Find Dewetting Onset Time

if dewet_or_not==0
   
    disp('Dewetting does not occur.')

elseif dewet_or_not==1    
    
    if smooth_or_not==1 
        areadata = movmean(areadata, smooth_window); %version of code for after R2016  
%         b = (1/smooth_window)*ones(1,smooth_window);  % for versions of Matlab before R2016                                                                       
%         areadata = filter(b,1,areadata);
    end
    
    
    


%  Find region of interest for linear fit of dewetting
% (comment out this section if all you want is the smoothed graph)


    t = 0; % define delay time point after which you want to start the analysis
    Area(2,:) = areadata;
    onset_time_indices = find(Area(2,:) < upperbound & Area(1,:) > t);
    startpoint = onset_time_indices(1);

    secondhalf = find(Area(2,:) < lowerbound & Area(1,:) > t);
    endpoint = secondhalf(1);

    dewetsize = startpoint - endpoint + 1;
    dewetting_curve = zeros(dewetsize, 2);
    k0 = 0;

    for i = startpoint:1:endpoint
        k0 = k0 + 1;  
        dewetting_curve(k0,:) = [timedata(i), areadata(i)];
    end

    dewetting_x = dewetting_curve(:,1);
    dewetting_X = [ones(length(dewetting_x),1) dewetting_x];
    dewetting_y = dewetting_curve(:,2);
    format long
    fit = dewetting_X\dewetting_y; % see MATLAB linear regression
    dewetting_y_calculated = dewetting_X*fit;
%% Plot fitted data and display dewetting onset time

    figure, hold on 
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial')
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName'   , 'Arial')
    set( gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;

    plot(timedata,areadata,'o')
    plot(dewetting_x,dewetting_y_calculated,'c-','LineWidth',2);
    print('-depsc2',strcat(fname,'_graph_fit.eps'));
    print('-dtiff',strcat(fname,'_graph_fit.tiff'));
    
    DOT = (1-fit(1))/fit(2);
    disp(['The dewetting onset time is ', num2str(DOT), ' s.'])

    Rsq = 1 - sum((dewetting_y - dewetting_y_calculated).^2)/sum((dewetting_y - mean(dewetting_y)).^2);
    disp(['The R-squared value for the linear fit is ', num2str(Rsq),'.'])


end
%% Switch warnings on back again

 warning('on','all');

fid=fopen(strcat(fname,'_DataProcessingParameters.txt'),'w'); %saves parameters used in file for analysis 
fprintf(fid, 'dewet_or_not = %d \n', dewet_or_not);
fprintf(fid, 'upperbound = %.2f \n', upperbound);
fprintf(fid, 'lowerbound = %.2f \n', lowerbound);
fprintf(fid, 'smooth_or_not = %d \n', smooth_or_not);
fprintf(fid, 'smooth_window = %d \n', smooth_window);
fprintf(fid, 'DOT = %.2f \n', DOT);
fprintf(fid, 'Rsq = %.3f \n', Rsq);
fprintf(fid, 'Time delay: %.3f \n', t);

fclose(fid);