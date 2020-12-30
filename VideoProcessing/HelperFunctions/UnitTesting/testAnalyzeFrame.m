%% Analyze a single video frame
function tests = testAnalyzeFrame
    tests = functiontests(localfunctions);
end


function testFrame(testCase)
    input_vid = testCase.TestData.input_vid;
    analys = testCase.TestData.analys;
    params = testCase.TestData.params;
    outputs = testCase.TestData.outputs;
    cur_frame_num = 6800;
    
    analyzeFrame(input_vid, cur_frame_num, analys, params, outputs, 0);
end

%% Optional File Fixtures
function setupOnce(testCase)
     close all;
     
%   initialize param's
        H_thresh_low = .422;
        H_thresh_high = .500;
        S_thresh_low = .104; %.164 <--- saturation boundaries have a substantial impact on video thresholding!
        S_thresh_high = .271; %.233
        V_thresh_low = .490; %.490
        V_thresh_high = .761; %.761
     
        field1 = 'rm_pix';  val1 = 250;
        field2 = 'skip';  val2 = 0;
        field3 = 't0';  val3 = 80;
        field4 = 'area';  val4 = 2330;
        field5 = 'bg';  val5 = val3 + 5;
        field6 = 'fit_type';  val6 = 1; % circle fit
        field7 = 'H_low'; val7 = H_thresh_low;
        field8 = 'H_high';  val8 = H_thresh_high;
        field9 = 'S_low';  val9 = S_thresh_low;
        field10 = 'S_high';  val10 = S_thresh_high;
        field11 = 'V_low';  val11 = V_thresh_low;
        field12 = 'V_high';  val12 = V_thresh_high;
        
        params = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5,...
                        field6,val6,field7,val7,field8,val8,field9,val9,field10,val10,...
                        field11,val11,field12,val12);
                    
                    
        field1 = 'falsecolor'; val1 = 1;
        field2 = 'analyzed'; val2 = 1;
        field3 = 'masks'; val3 = 1;
        field4 = 'bw_mask'; val4 = 1;
        field5 = 'animated_plot'; val5 = 1;      
 
        outputs = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5); % output videos


%     [file_name,~] = getFile();
    file_name = '/Volumes/Extreme SSD/LubricinData/07 2020/7-18-20/1 ugmL HPL2/finalCode/1 ugmL lubricin DS HPL2 37C 1.avi';

    [analys.crop_rect, vid] = startVideo(file_name,params.area); % Initialize video
    [analys.area_mask, analys.outer_region, analys.shadow, analys.max_area] = ... % Set areas
        setAreas(vid, analys.crop_rect, params.area, params.fit_type); 
    
        %%
    testCase.TestData.input_vid = vid;
    testCase.TestData.analys = analys;
    testCase.TestData.params = params;
    testCase.TestData.outputs = outputs;
     
end