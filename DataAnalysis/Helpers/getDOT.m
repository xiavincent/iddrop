function [result,params] = getDOT(fname, params, time, area)

    if (params.dewet == 1) % video dewets
        while (1) % loop
            params = getBounds(params); % user-specified lower and upper bounds 

            % find the starting and stopping indices
            params.delay = 0; % define delay time point after which you want to start the analysis
            
            time_indices = find(time > params.delay); % region past delay point
            below_ub = intersect(find(area < params.ubound),time_indices); % find indices where area dips below upper bound
            below_lb = intersect(find(area < params.lbound),time_indices);  % find indices where area dips below the lower bound
            
            begin = min(below_ub); % find first index where area dips below upper bound
            stop = min(below_lb); % find first index where area dips below lower bound
            
            result = calcFit(fname,time,area,begin,stop); % calculate line of best fit
            
            answer = questdlg('Redo fit?', 'Confirm DOT', 'Yes','No','No'); % two options, with 'No' set as default
            switch answer % exit loop based on user input
                case 'No'
                    break;
                case '' % user doesn't give a response
                    break; 
                case 'Yes' % reperform bound fitting
            end  
            
        end     
    else % video doesn't dewet      
        disp('Dewetting does not occur.');
    end

end

% fills in the lower and upper bounds on the params struct based on user input
function params = getBounds(params)
    
    data_processing = inputdlg({'Select upper bound',...
                                'Select lower bound'},...
                                'DOT fit bounds',...
                                [1 20; 1 20],{'0.98','0.90'});

    params.ubound = str2double(data_processing{1}); %gets this from input dialog
    params.lbound = str2double(data_processing{2}); %gets this from input dialog
   
end




