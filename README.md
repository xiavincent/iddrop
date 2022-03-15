## Hue-saturation-value based segmentation for analyzing thin film breakup of model films supplemented with varying lipid composition mixtures
see 'ImproveEdgeDetect' branch for a code version that includes the legacy edge detection algorithm.

In contrast to the 'HonorsThesisCode' branch, this code version only analyzes the central 56% of the total area of the dome; this region is defined by shrinking the radius of the user-specified dome area to 75% of its original area. 

In contrast to the 'HonorsThesisCode_retainCenter' branch, this code version DOES NOT detect dry regions which are surrounded by liquid on all sides.


## Interfacial Dewetting and Drainage Optical Platform (i-DDrOP)

i-DDrOP analysis of thin film dewetting patterns in videos using hydrophilic glass domes with lubricin/water as base media. 

Includes two main code files:
- *Video processing*: outputs a file containing the film's wet area for every time point.
- *Data analysis*: calculates dewetting onset time for a thin film, given a file containing wet area vs time information.

Matlab scripts (*.m*) are included along with respective helper function folders. Contact Vincent Xia (vxia@stanford.edu) with questions.

