# CorrCA_for_P300
Identifying reliable neural components and peak latency using CorrCA.

Prerequisite
1. Statistical and machine learinng toolbox
2. Signal processing toolbox
3. All the datasets must be in the same folders where all the .m files and channel location files exist.
4. Use [1]'s proceesure to extract and filter the single trials of EEG data.
5. Downlaod EEG data from http://bci.epfl.ch/p300 and relevant codes. 

The code is illustrated with a P300 data set recorded during an OddBall paradigm [1].

Please modify the codes according to your own datasets.


CorrCA is developed by Dmochowski et al., [2] to extract the reliable brain responses across multiple trials. The objective of CorrCA is to find the linear combination of EEG channels that maximize the correlation between trials. For more details on CorrCA, refer to [3].

The codes were used to find the reliable components embeeded inside a P300 EEG data and also to find the peak latency of P300.
Lower ITC scores showed the fatigue and lack of concentration of subjects and higher ITC scores showed subject was highly concentrated and motivated during EEG data recording. The result was confirmed based on the ITC scoes and already reported information about corresponding subjects behavior in [1]. 

## Channel location:
### coord: Channel location with 8 electrodes.
### coord1: Channel location with 16 electrodes.

## .m files:
### est_K_shift: Statistical non-parametric test for finding the statistically significant CorrCA components.
### extract_P300: It will execute the Preprocessing part.
### forward_modelVisual: Draw the topoplots
### ploterp: plot erp of the EEG data
### regInv: Generate a regularized inverse within trial covariance matrix usig Singular value decomposition method
### topoplot: Draw the toplots
### ttest_ITC: perform t test between ITC values of target trial cohorts and non target trial cohorts.
### Utilities Folder contains preprocessing techniques such as windsorization, Normalization. Utilities folder was created by Hoffman et al.,[1].

## How to run the Code:
Before runing the code user must first extracts the single trials using [1]'s shared codes.
You will find the subjects data in the name started with S then subject's ID followed by sessions.

It is very important to save the subject's data in the same folder.

1. Go to the extract_P300.m 
set the path for utilities folder provided by [1].



Copy the line shown in the image and run in the command line. Here the first line shown is for subject 6 and second line is for subject 8.

2. To extract the non-target trials, in the line number 68 put y == -1


You can also uncomment the different parts to visulize the histogram of z score values and  plot between trials after applying  covariance rejection  Vs trials before applying covariance rejection method.

3. corrca_plot.m generates:

#### a. ITC values of CorrCA components, CorrCA components, projection matrix, forward model.
#### b. It generates the plot of SNR, ERP, topoplots of each subjects consistent with first and second CorrCA components.

4. To generate only topoplots of each subject use forward_modelVisual.m file. To use this .m file at first you need to save the forward model of each subjets for target trials and non-target trials. If you used [1] data then you should have total 16 files 8 from target trials and 8 from non-target trials.

### If you use your own datasets then change the sample frequency, channel location file.


## References:

### [1] U. Hoffmann, J. M. Vesin, T. Ebrahimi, and K. Diserens, "An efficient P300-based brain-computer interface for disabled subjects," Journal of Neuroscience Methods, vol. 167, no. 1, pp. 115–125, 2008.
### [2] J. P. Dmochowski, P. Sajda, J. Dias, and L. C. Parra, "Correlated components of ongoing EEG point to emotionally laden attention - a possible marker of engagement?" Frontiers in Human Neuroscience, 2012.
### [3] L. C. Parra, S. Haufe, and J. P. Dmochowski, "Correlated components analysis-Extracting reliable dimensions in multivariate data," arXiv. 2018.
















