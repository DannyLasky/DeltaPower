function [avgMagArr,startEpochOffset,DSTCheck] = LaskyAlign(fileNameEDF,epochLength,epochCount,avgMagArr)

% Works with DannyDelta_v6.m to align arrays within the 6:30:00-6:30:00 
% window. Needs to perform adjustments for daylight savings time since our 
% lab computers were not adjusting to DST but our vivarium lights and 
% experiments were.

% Finalized 7/11/2022, Danny Lasky

EDFInfo = edfinfo(fileNameEDF);
startTime = EDFInfo.StartTime;
startTimeSplit = split(startTime,".");
startTimeNum = str2double(startTimeSplit);

%% Zeitgeber time = 0 (lights on) always at 6:30 on clocks
% During DST, Jesse came in at the same relative time, moves his clock
% forward an hour and the vivarium lights turning on moves forward an hour
% The computers did not shift forward to account for DST (imagine it being
% stuck in mountain time instead of moving to central time). The EDFs 
% recorded during DST must be aligned to zeitgeber 0 by reading the EDF 
% from 5:30 when lights come on according to the computers)

tempDateSplit = split(EDFInfo.StartDate,".");       % Checks the EDF date for whether it was during DST
tempDateSplit(3) = strcat('20',tempDateSplit(3));
correctDate = strcat(tempDateSplit(1),'-',tempDateSplit(2),'-',tempDateSplit(3),' 12');
EDFTime = datetime(correctDate, 'timezone', 'America/Chicago','InputFormat','dd-MM-yyyy HH');
DSTCheck = isdst(EDFTime)

if DSTCheck == 0                % If during DST aligns to an hour earlier since the computers were recoding an hour earlier relative to the vivarium lights
startTimeBase = [6;30;0];
elseif DSTCheck == 1
startTimeBase = [5;30;0];
end

startTimeOffset = startTimeNum - startTimeBase;     % Calculates total offset from the vivarium lights coming on
startSecOffset = startTimeOffset(1,1)*3600 + startTimeOffset(2,1)*60 + startTimeOffset(3,1);
startEpochOffset = round(startSecOffset/epochLength);

endEpochOffset = 86400/epochLength - fix(startEpochOffset + epochCount);
tempWidth = width(avgMagArr);

if startEpochOffset > 0         % Adjusts the epoch array to begin at ZT0 (lights coming on)
    avgMagArr  = [NaN(startEpochOffset,tempWidth);avgMagArr];
elseif startEpochOffset < 0
    cutEpochs  = abs(startEpochOffset) + 1;
    avgMagArr  = avgMagArr(cutEpochs:end,:);
end

if endEpochOffset > 0
    avgMagArr  = [avgMagArr;NaN(endEpochOffset,tempWidth)];
elseif endEpochOffset < 0
    cutEpochs  = abs(endEpochOffset);
    avgMagArr  = avgMagArr(1:end-cutEpochs,:);
end

disp(length(avgMagArr))     % Should display a count of 21600 if epoch length is 4 seconds (60*60*24/4 = 21600)
