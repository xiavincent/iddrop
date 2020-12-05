function getDOT(fname, params, time, area)


    while 1
        if dewet_or_not==0
            disp('Dewetting does not occur.')

        elseif dewet_or_not==1    

            if smooth_or_not == 0
                a = movmean(area, smooth_window); %version of code for after R2016  
            end
            
        %  Find region of interest for linear fit of dewetting
        % (comment out this section if all you want is the smoothed graph)

            delay = 0; % define delay time point after which you want to start the analysis
%             onset_time_index = find(area < upperbound) && find(time > delay);

            % find the starting and stopping indices
            begin = find(area < upperbound) && find(time > delay); % perform a short-circuit 'and' between the valid indices
            stop = find(area < lowerbound) && find(time > delay);
            
            x = time(begin:stop); % use this to calculate a one parameter linear regression
            X = [ones(length(x),1), x]; % use this to calculate a two parameter linear regression
            y = area(begin:stop); % y values of line of interest
            
            beta = X\y; % coefficients of the linear regression (see Matlab linear regression documentation)           
            y_calc = X*beta; % calculate area values of line of best fit using matrix multiplication
            
            plot(x,y_calc);
            
            
            
            plotFit(fname );  % plot fitted data and display dewetting onset time
        
       
    end

end


function plotFit(fname, dewetting_x, dewetting_y_calculated)

    figure, hold on 
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial')
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName', 'Arial')
    set( gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;

    plot(time,area,'.')
    plot(dewetting_x,dewetting_y_calculated,'c-','LineWidth',2);
    print('-depsc',strcat(fname,'_graph_fit.eps')); % save as encapsulated postscript

    DOT = (1-fit(1))/fit(2);
    disp(['The dewetting onset time is ', num2str(DOT), ' s.'])

    Rsq = 1 - sum((dewetting_y - dewetting_y_calculated).^2)/sum((dewetting_y - mean(dewetting_y)).^2);
    disp(['The R-squared value for the linear fit is ', num2str(Rsq),'.'])
    
end