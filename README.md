## Hue-saturation-value based segmentation for use with Novartis project

This code uses cutoff values for hue-saturation-value image channels to detect the dry regions of the dome and turn the image into a black and white image. It filters out abnormally small regions that might cause errors in the result and outputs a video that highlights the dry regions of the analysis. The default output frame rate is 20 fps, but this can be adjusted in the code. 

See 'ImproveEdgeDetect' branch for the legacy edge detection algorithm, which offers an alternative method of analyzing these videos.

## Interfacial Dewetting and Drainage Optical Platform (i-DDrOP)

i-DDrOP analysis of thin film dewetting patterns in videos using hydrophilic glass domes with lubricin/water as base media. 

Includes two main code files:
- *Video processing*: outputs a file containing the film's wet area for every time point.
- *Data analysis*: calculates dewetting onset time for a thin film, given a file containing wet area vs time information.

Matlab scripts (*.m*) are included along with respective helper function folders. Contact Vincent Xia (vxia@stanford.edu) with questions.

