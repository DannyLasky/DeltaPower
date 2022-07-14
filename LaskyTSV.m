function [TSVMatrix,sleepState] = LaskyTSV(TSVMatrix,startEpochOffset,currentFile)

% Works up the scored TSV file by removing unnecessary columns and aligning
% it to the predefined window that the EDF was aligned to. Finally produces
% sleep state specific matrices in preparation for graphing.

% Finalized 7/11/2022, Danny Lasky

%% General TSV work-up
TSVMatrix(:,[2,3,5,7,8]) = [];  % Removes all columns that aren't start epoch, sleep state, or length (in seconds)

% Align TSV in pre-established 5:30 (during DST because computers) or 6:30 window
TSVMatrix(:,1) = TSVMatrix(:,1) + startEpochOffset + 1;
TSVMatrix(:,3) = TSVMatrix(:,3)/4;      % Change length to be in epochs instead of seconds (hard coded to be 4 second epochs)

% New column for end epoch 
TSVMatrix(:,4) = TSVMatrix(:,1) + TSVMatrix(:,3) - 1;

% Display number of artifact bouts in recording for troubleshooting purposes
artBouts = find(TSVMatrix(:,2) == 0)';      % 0 = artifact epochs in TSV
artBoutsString = num2str(artBouts);
artBoutsSum = sum(TSVMatrix(:,2) == 0);
fprintf('%s has %d artifact bouts at position(s) %s\n',currentFile,artBoutsSum,artBoutsString);

%% Add columns for specific parameters and clean matrix
% Remove entire rows or epochs of rows that are outside the defined 24-hour period
tempArrEaly = (TSVMatrix(:,1));
tempArrEaly((tempArrEaly) < 1) = 1;
TSVMatrix(:,1) = tempArrEaly;

tempArrLate = (TSVMatrix(:,4));
tempArrLate((tempArrLate) > 21600) = 21600;
TSVMatrix(:,4) = tempArrLate;

RemoveEarly = diff(TSVMatrix(:,1)) == 0;
TSVMatrix(RemoveEarly,:) = [];

RemoveLate = diff(TSVMatrix(:,4)) == 0;
RemoveLate = [0;RemoveLate];
RemoveLate = logical(RemoveLate);
TSVMatrix(RemoveLate,:) = []; 

% Recalculate epoch length column
TSVMatrix(:,3) = TSVMatrix(:,4) - TSVMatrix(:,1) + 1;

%% Prepare sleep state specific matrices
sleepState = NaN(21600,1);

for i = 1:height(TSVMatrix)
    tempAdd = transpose(TSVMatrix(i,1):TSVMatrix(i,4));
    tempAdd(:,2) = TSVMatrix(i,2);
    sleepState(TSVMatrix(i,1):TSVMatrix(i,4)) = tempAdd(:,2);
end
