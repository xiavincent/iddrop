# Interfacial Dewetting and Drainage Optical Platform (i-DDrOP)

i-DDrOP analysis of thin film dewetting patterns in videos using hydrophilic glass domes with lubricin/water as base media. 

Main folders:
- *VideoProcessing*: outputs a file containing the film's wet area for every time point.
- *DataAnalysis*: calculates dewetting onset time for a thin film, given a file containing wet area vs time information.
- *GenerateAnalyzedVideo*: creates a copy of the original video where frames are skipped
- *RGB_FilmTracking*: tracks the RGB intensity over time at specified points in the thin film

The main branch uses edge detection algorithm to calculate dewetting onset time, but may not work for all films. A hue-saturation-value based segmentation branch is included as legacy.

Matlab scripts (*.m*) are included along with respective helper function folders. Contact Vincent Xia (vxia@stanford.edu) with questions.

<img width="805" alt="Screen Shot 2021-01-18 at 12 47 32 PM" src="https://user-images.githubusercontent.com/33092902/104961522-56694d80-598b-11eb-847d-23917f26edb0.png">
