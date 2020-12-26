% Writes the output videos for a given frame based on user-specified output types 
% return the wet area
%% INPUT:
% output_vids: structure containing initialized Matlab videos to be outputted 

%% FUNCTION:
function writeOutputVids(gray_frame, crop_frame, orig_frame, HSV_mask, binarize_mask, label_dewet_img,...
                              t0_frame_num, cur_frame_num, wet_area,...
                              input_fps, output, output_vids)
                          
        vid_time = cur_frame_num/input_fps; % raw video time
        graph_time = vid_time - t0_frame_num/input_fps; % adjusts time for skipped frames and initial frame rate  

        frame_info = sprintf('Frame: %d | Video time: %.3f sec | Graph time: %.3f sec | Area: %.3f', cur_frame_num, vid_time, graph_time, wet_area); % prints frame #, time stamp, and area for each mp4 video frame

%% 
% Output black & white mask video:

        if (~output.bw_mask) % make a movie of the black/white final mask frames       
            final_mask = label_dewet_img > 0;
            output_img = insertText(final_mask,[100 50],frame_info,'AnchorPoint','LeftBottom'); % requires Matlab Computer Vision Toolbox            
            writeVideo(output_vids.bw,output_img); % writes video with analyzed frames  
        end
%% 
% Output falsecolor:        

        if (~output.falsecolor)  % make a falsecolor overlay of our labelled final mask over the original grayscale image 
            FinalImgFuse = labeloverlay(gray_frame,label_dewet_img);
%             FinalImgFuse = imfuse(finalMask,gray_frame,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); %create falsecolor overlay of binary mask over original image    
            falseColorInfo = sprintf('red = binary mask | green = original img | yellow = both'); % prints false color info                
            output_img = insertText(FinalImgFuse,[100 50],frame_info,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox
            output_img = insertText(output_img,[100 100],falseColorInfo,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox    
            writeVideo(output_vids.falsecolor, output_img); %writes video with analyzed frames
        end        
%% 
% Output analyzed frames:
        if (~output.analyzed) 
            frame_info = sprintf('Frame: %d | Time: %.3f sec ', cur_frame_num , graph_time); % prints frame #, time stamp, and area for each mp4 frame
            image = insertText(orig_frame,[30 725],frame_info,'FontSize',55,'BoxColor','white','AnchorPoint','LeftBottom'); %requires Matlab Computer Vision Toolbox
            writeVideo(output_vids.analyzed, image);
        end
%% 
% Output individual masks:       

        if(~output.masks) 
            box_color = 'green';
           
            im0 = insertText(crop_frame,[100 50],"orig image",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            im1 = insertText(im2uint8(HSV_mask),[100 50],"HSV mask",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
                fuse = imfuse(im2uint8(HSV_mask),im2uint8(binarize_mask),'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); %create falsecolor overlay of area mask with HSV mask
            im2 = insertText(fuse, [100 50],'HSV w/ binarize overlay','FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            im3 = insertText(im2uint8(binarize_mask),[100 50],"Binarize mask",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');            
            im6 = insertText(label2rgb(label_dewet_img),[100 50],'final mask','FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            
%             im7 = insertText(im2uint8(_____),[100 50],"HSV mask after removing small objects and small mask holes",'FontSize',18,'BoxColor', box_color,'AnchorPoint','LeftBottom');
            
          blank = zeros(size(im0)); % use this to fill in gaps of the montage if there's not enough videos to output
            concat1 = cat(1,im0,im1,im2); %concatenate the images together
            concat2 = cat(1,im3,im6,blank);
            concatFinal = cat(2,concat1,concat2);
            
            finalImage = insertText(concatFinal,[300 50],frame_info,'FontSize',20,'AnchorPoint','LeftBottom'); %requires Matlab Computer Vision Toolbox
            writeVideo(output_vids.masks,finalImage);
        end     
end