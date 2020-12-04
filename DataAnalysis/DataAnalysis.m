%% DATA PROCESSING OF DEWETTING FROM TEXT FILE

% Takes a txt file of wet area vs time as an input and calculates the dewetting onset time
% TODO: returns a txt file of smoothed wet area vs time

% Kiara Cui and Vincent Xia, Nov 2020
%%

startup(); % add subfolders to path
area_data = readFile();  % retrieve area data from .txt file
plotRaw(area_data); % plot raw data 


%% Dialog box to determine how to process data

getParams();

%% Find Dewetting Onset Time

if dewet_or_not==0
   
    disp('Dewetting does not occur.')

elseif dewet_or_not==1    
    
    if smooth_or_not==1 
        wet_area_data = movmean(wet_area_data, smooth_window); %version of code for after R2016  
    end
    

%  Find region of interest for linear fit of dewetting
% (comment out this section if all you want is the smoothed graph)

    t = 0; % define delay time point after which you want to start the analysis

    onset_time_indices = find(area_data(:,3) < upperbound & area_data(:,2) > t);
    startpoint = onset_time_indices(1);

    secondhalf = find(area_data(:,3) < lowerbound & area_data(:,2) > t);
    endpoint = secondhalf(1);

    dewetsize = startpoint - endpoint + 1;
    dewetting_curve = zeros(dewetsize, 2);
    k0 = 0;

    for i = startpoint:1:endpoint
        k0 = k0 + 1;  
        dewetting_curve(k0,:) = [time_data(i), wet_area_data(i)];
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

    plot(time_data,wet_area_data,'.')
    plot(dewetting_x,dewetting_y_calculated,'c-','LineWidth',2);
    print('-depsc2',strcat(fname,'_graph_fit.eps'));
    print('-dtiff',strcat(fname,'_graph_fit.tiff'));
    
    DOT = (1-fit(1))/fit(2);
    disp(['The dewetting onset time is ', num2str(DOT), ' s.'])

    Rsq = 1 - sum((dewetting_y - dewetting_y_calculated).^2)/sum((dewetting_y - mean(dewetting_y)).^2);
    disp(['The R-squared value for the linear fit is ', num2str(Rsq),'.'])


end

saveParams(); % save parameters
