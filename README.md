## Hue-saturation-value based segmentation code for analyzing model film breakup for lipid composition mixtures
In contrast to the 'HonorsThesisCode' branch, this code also detects dry regions in the center of the film that are surrounded by liquid. This is good for analyzing videos that exhibit dewetting at the center of the film, but this detection of dry regions in the center of the film comes at the expense of increased noise in the analysis (i.e., false positive detection of dry regions)

see 'ImproveEdgeDetect' branch for legacy edge detection algorithm

## Interfacial Dewetting and Drainage Optical Platform (i-DDrOP)

i-DDrOP analysis of thin film dewetting patterns in videos using hydrophilic glass domes with lubricin/water as base media. 

Includes two main code files:
- *Video processing*: outputs a file containing the film's wet area for every time point.
- *Data analysis*: calculates dewetting onset time for a thin film, given a file containing wet area vs time information.

Matlab scripts (*.m*) are included along with respective helper function folders. Contact Vincent Xia (vxia@stanford.edu) with questions.

