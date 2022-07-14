function [fullArr,fs,fileNameEDF,TSVMatrix] = LaskyRead(currentFile, useTSV)

% Reads in the EDF (and TSV if being used). Identifies the right frontal
% channel and then expands the data array. Script will pull an error if the
% EDF was not sampled at 512 Hz, the TSV (if provided) was not sleep
% scored in 4 second epochs, and if the TSV (if provided) did not have a
% minimum bout length of 16 seconds (4 epochs). These are all parameters
% we wanted hold constant in our experiments. The errors can be changed or
% removed at the bottom of this script as necessary.

% Finalized 7/11/2022, Danny Lasky

%% Read in EDF and TSV
fileNameEDF = strcat(currentFile,'.edf');
EDFData = edfread(fileNameEDF);

if useTSV == 1
inputTSV = strcat(currentFile,'.tsv');
newTSVName = strcat(currentFile,'.txt');    % Need to convert .tsv to .txt to read in properly
copyfile(inputTSV, newTSVName)
TSVMatrix = readmatrix(newTSVName);
end

if useTSV == 0
    TSVMatrix = 'noTSV';
end

%% Selects the RF signal and expands the array
EDFInfo = edfinfo(fileNameEDF);
signalNames = EDFData.Properties.VariableNames;
RFNumber = find(contains(signalNames, 'RF'));       % Identifies RF signal by finding channel that contains "RF"

RFData = EDFData.(RFNumber);	% Expands the RF array
fullArr = cell2mat(RFData);

%% Check for EDF RF sampling frequency of 512 Hz and proper TSV conversion
fs = EDFInfo.NumSamples(RFNumber,1);

if fs ~= 512
    error('EDF RF sampling frequency is not 512 Hz')    % Checks if EDF was sampled at 512 Hz and pulls an error if not
end

if useTSV == 1
    if any(mod(TSVMatrix(:,6),4) ~= 0)
        error('TSV not divided into 4 second epochs')   % Checks if TSV was sleep scored in 4 seconds epochs and errors if not
    elseif any(TSVMatrix(:,6) < 16)
        error('TSV minimum length not 4 epochs (16 seconds)')   % Checks if TSV had a minimum bout length of 16 seconds (4 epochs) and errors if not
    end
end
