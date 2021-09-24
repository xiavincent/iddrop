# Interfacial Dewetting and Drainage Optical Platform (i-DDrOP)

i-DDrOP analysis of thin film dewetting patterns in videos using hydrophilic glass domes with lubricin/water as base media. See "RebaseWorkingHSV" branch for most recent version of code that was last updated in April 2021 for analyzing data for the Novartis project.

Main folders:
- *VideoProcessing*: outputs a file containing the film's wet area for every time point.
- *DataAnalysis*: calculates dewetting onset time for a thin film, given a file containing wet area vs time information.
- *GenerateAnalyzedVideo*: creates a copy of the original video where frames are skipped
- *RGB_FilmTracking*: tracks the RGB intensity over time at specified points in the thin film

The main branch uses edge detection algorithm to calculate dewetting onset time, but may not work for all films. A hue-saturation-value based segmentation branch is included as legacy.

Matlab scripts (*.m*) are included along with respective helper function folders. Contact Vincent Xia (vxia@stanford.edu) with questions.

-------------------------

<img width="809" alt="Screen Shot 2021-01-18 at 3 06 05 PM" src="https://user-images.githubusercontent.com/33092902/104969938-b1587000-599e-11eb-80b5-56b3628beb0a.png">
