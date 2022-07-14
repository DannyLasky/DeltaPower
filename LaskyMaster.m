% Master script that calls for other scripts. Allows for a centralized
% place to observe the process and easily tell which individual functions
% result in an error. These scripts will perform full-signal normalization,
% calculate band power, normalize delta power and gamma power against the
% other band powers, identify and remove artifact, and provide graphical
% output.

% Finalized 7/11/2022, Danny Lasky

%% Initialize file array
fileArr = ["TBI1" "TBI2"];

%% Begin full file loop and set input directory
for fileCount = 1:length(fileArr)
useTSV = 1;                             % If using a TSV output from Sirenia Sleep, use = 1. If no TSV provided = 0
currentFile = fileArr(fileCount);
cd 'M:\EEG files\2022\DORA THIP Paper\Test';    % This will be your file path to the EDFs (and TSVs if using)

%% Read in EDF and TSV, select the RF signal and expand the array
[fullArr,fs,fileNameEDF,TSVMatrix] = LaskyRead(currentFile, useTSV);

%% Apply Jesse Pfammatter's 60-Hz filter, high-pass filter, and full EEG normalization
% These were written by a previous postdoc and requires the normalizeEEG.m,
% sixtyHzFilt_EEG.m, highPassChebyshev1Filt_EEG.m, and fit_gauss.m scripts 
% to be run. This code will apply sixty Hz and highpass filters and then 
% perform full signal Gaussian normalization to make EEGs comparable across
% animals. A temporary figure will show the Gaussian curve fitting the 
% script performs. The code can also be found in its original repository at
% https://github.com/jessePfammatter/detectSWDs
[normSignal, sig, modelfit, mu] = normalizeEEG(fullArr,fs);

%% Define an epoch, find sampling points per epoch and an epoch count
epochLength = 4;                        % How many seconds you would like an epoch to be
epochPts = fs*epochLength;              % Number of points in an epoch determined by epoch length and sampling frequency
epochCount = length(fullArr)/epochPts;  % The number of epochs in your RF EEG  

%% Quantify delta and gamma power using Jones's method
[avgMagArr,signalMax,signalMin,signalStd] = LaskyPower(normSignal,epochPts,fs);

%% Align epochs in 6:30:00am-6:30:00am window
[avgMagArr,startEpochOffset,DSTCheck] = LaskyAlign(fileNameEDF,epochLength,epochCount,avgMagArr);

%% Work up the TSV and make sleep state specific matrices
if useTSV == 1
    [TSVMatrix,sleepState] = LaskyTSV(TSVMatrix,startEpochOffset,currentFile);
end

if useTSV == 0
    sleepState = 'noTSV';
end

%% Normalize the band powers, remove artifact, divide into hourly segments and create full epoch and hourly output
[finalMatrix,finalTable,hourlyMatrix,hourlyTable,artDeltaSum,artGammaSum] = LaskyNormHour(epochLength,avgMagArr,sleepState,useTSV);

%% Create supplementary table, create output directory, and save off tables
suppTable = table(modelfit,sig,mu,signalMax,signalMin,signalStd,artDeltaSum,artGammaSum,DSTCheck);

outputDir = fullfile('M:\EEG files\2022\DORA THIP Paper\Test',currentFile);
mkdir(outputDir);   % Creates a new folder for output. Will create new folders for each file run to keep organized.
cd(outputDir);

writetable(finalTable,'FinalTable.csv')
writetable(hourlyTable,'HourlyTable.csv')
writetable(suppTable,'SuppTable.csv')

if useTSV == 1
    TSVTable = array2table(TSVMatrix,'VariableNames',{'Start Epoch','Sleep State','Epoch Length','End Epoch'});
    writetable(TSVTable,'TSVTable.csv')
end

%% Create hourly delta gamma graphs across 24 hours. Will separate by sleep state if TSV provided.
[empty] = LaskySingle24Hr(hourlyMatrix,hourlyTable,fileNameEDF,useTSV);

end

%% Create hourly delta power graphs across 24 hours for multiple files broken into treatments. Capable of graphing 6 treatments.
list1 = ["TBI1"];
    
list2 = ["TBI2"];

list3 = "None";
list4 = "None";
list5 = "None";
list6 = "None";

inputDir = 'M:\EEG files\2022\DORA THIP Paper\Test';
outputDir = 'M:\EEG files\2022\DORA THIP Paper\Test';
legendNames = ["TBI1" "TBI2"];
graphTitle = "TBI Only";
sleepState = "All";

[num1] = LaskyGroup24Hr(list1, list2, list3, list4, list5, list6, inputDir, outputDir, legendNames, graphTitle, sleepState);
