function [num1] = LaskyGroup24Hr(list1, list2, list3, list4, list5, list6, inputDir, outputDir, legendNames, graphTitle, sleepState)

% Works with DannyDelta_v6.m to produce a graph of 24-hour delta power
% across multiple treatments. Produces a graph with hourly points and SEM 
% error bars. Needs at least two treatments (list1 and list2) to function.
% If not using a list as a treatment it must be filled in as "None". Sleep
% State must be specifed as either "All", "Wake", or "NREM". 
% Finalized 7/11/2022, Danny Lasky

%% For sleep state
if sleepState == "All"
    columnNum = 3;
elseif sleepState == "Wake"
    columnNum = 6;
elseif sleepState == "NREM"
    columnNum = 9;
end

%% Creates matrix 1 from files specified in list 1
num1 = length(list1);
matrix1 = zeros(24,num1);

for fileCount = 1:num1
currentFile = list1(fileCount);
tempDir = fullfile(inputDir,currentFile);
cd(tempDir)

hourlyMatrixTemp = readmatrix('HourlyTable.csv');

matrix1(:,fileCount) = hourlyMatrixTemp(:,columnNum);
end

%% Creates matrix 2 from files specified in list 2
num2 = length(list2);
matrix2 = zeros(24,num2);

for fileCount = 1:num2
currentFile = list2(fileCount);
tempDir = fullfile(inputDir,currentFile);
cd(tempDir)

hourlyMatrixTemp = readmatrix('HourlyTable.csv');

matrix2(:,fileCount) = hourlyMatrixTemp(:,columnNum);
end

%% Creates matrix 3 from files specified in list 3, skips if listed as "None"
if list3 ~= "None"
    num3 = length(list3);
    matrix3 = zeros(24,num3);

    for fileCount = 1:num3
        currentFile = list3(fileCount);
        tempDir = fullfile(inputDir,currentFile);
        cd(tempDir)

        hourlyMatrixTemp = readmatrix('HourlyTable.csv');

        matrix3(:,fileCount) = hourlyMatrixTemp(:,columnNum);
	end
end

%% Creates matrix 4 from files specified in list 4, skips if listed as "None"
if list4 ~= "None"
    num4 = length(list4);
    matrix4 = zeros(24,num4);

    for fileCount = 1:num4
        currentFile = list4(fileCount);
        tempDir = fullfile(inputDir,currentFile);
        cd(tempDir)

        hourlyMatrixTemp = readmatrix('HourlyTable.csv');

        matrix4(:,fileCount) = hourlyMatrixTemp(:,columnNum);
    end
end

%% Creates matrix 5 from files specified in list 5, skips if listed as "None"
if list5 ~= "None"
    num5 = length(list5);
    matrix5 = zeros(24,num5);

    for fileCount = 1:num5
        currentFile = list5(fileCount);
        tempDir = fullfile(inputDir,currentFile);
        cd(tempDir)

        hourlyMatrixTemp = readmatrix('HourlyTable.csv');

        matrix5(:,fileCount) = hourlyMatrixTemp(:,columnNum);
    end
end

%% Create matrix 6 from files specified in list 6, skips if listed as "None"
if list6 ~= "None"
    num6 = length(list6);
    matrix6 = zeros(24,num6);

    for fileCount = 1:num6
        currentFile = list6(fileCount);
        tempDir = fullfile(inputDir,currentFile);
        cd(tempDir)

        hourlyMatrixTemp = readmatrix('HourlyTable.csv');

        matrix6(:,fileCount) = hourlyMatrixTemp(:,columnNum);
    end
end

%% Find means and standard error of the means of listed treatments
mean1 = zeros(24,1);
SEM1  = zeros(24,1);
mean2 = zeros(24,1);
SEM2  = zeros(24,1);

if list3 ~= "None"
    mean3 = zeros(24,1);
    SEM3  = zeros(24,1);
end
    
if list4 ~= "None"
    mean4 = zeros(24,1);
    SEM4  = zeros(24,1);
end

if list5 ~= "None"
    mean5 = zeros(24,1);
    SEM5  = zeros(24,1);
end

if list6 ~= "None"
    mean6 = zeros(24,1);
    SEM6  = zeros(24,1);
end

for n = 1:24
    tempHour = matrix1(n,:);
    mean1(n) = mean(tempHour, 'omitnan');
    SEM1(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
end

for n = 1:24
    tempHour = matrix2(n,:);
    mean2(n) = mean(tempHour, 'omitnan');
    SEM2(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
end

if list3 ~= "None"
    for n = 1:24
        tempHour = matrix3(n,:);
        mean3(n) = mean(tempHour, 'omitnan');
        SEM3(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
    end
end

if list4 ~= "None"
    for n = 1:24
        tempHour = matrix4(n,:);
        mean4(n) = mean(tempHour, 'omitnan');
        SEM4(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
    end
end

if list5 ~= "None"
    for n = 1:24
        tempHour = matrix5(n,:);
        mean5(n) = mean(tempHour, 'omitnan');
        SEM5(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
    end
end

if list6 ~= "None"
    for n = 1:24
        tempHour = matrix6(n,:);
        mean6(n) = mean(tempHour, 'omitnan');
        SEM6(n) = std(tempHour, 'omitnan')/sqrt(sum(~isnan(tempHour)));
    end
end

cd(outputDir)

% Compiles treatment means and SEMs and saves off in a table with columns labeled with the animal ID
if list6 ~= "None"
    groupTable = table(mean1, SEM1, matrix1, mean2, SEM2, matrix2, mean3, SEM3, matrix3, mean4, SEM4, matrix4, ...
        mean5, SEM5, matrix5, mean6, SEM6, matrix6);
elseif list5 ~= "None"   
    groupTable = table(mean1, SEM1, matrix1, mean2, SEM2, matrix2, mean3, SEM3, matrix3, mean4, SEM4, matrix4, ...
        mean5, SEM5, matrix5);    
elseif list4 ~= "None"
    groupTable = table(mean1, SEM1, matrix1, mean2, SEM2, matrix2, mean3, SEM3, matrix3, mean4, SEM4, matrix4);    
elseif list3 ~= "None"
    groupTable = table(mean1, SEM1, matrix1, mean2, SEM2, matrix2, mean3, SEM3, matrix3);
elseif list3 == "None"
    groupTable = table(mean1, SEM1, matrix1, mean2, SEM2, matrix2);
end

finalTable = splitvars(groupTable,'matrix1','NewVariableNames',list1);
finalTable = splitvars(finalTable,'matrix2','NewVariableNames',list2);

if list3 ~= "None"
    finalTable = splitvars(finalTable,'matrix3','NewVariableNames',list3);
end

if list4 ~= "None"
    finalTable = splitvars(finalTable,'matrix4','NewVariableNames',list4);
end

if list5 ~= "None"
    finalTable = splitvars(finalTable,'matrix5','NewVariableNames',list5);
end

if list6 ~= "None"
    finalTable = splitvars(finalTable,'matrix6','NewVariableNames',list6);
end

writetable(finalTable, strcat(graphTitle,{' '},sleepState,'.csv'))

%% Graph all the 24-hour delta power treatments together for the specified sleep state
figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2 0.2 0.7 0.7]);

p1 = plot(1:24,mean1,'LineWidth',1.5,'Color','#0072BD');
set(gca,'FontSize',16)
hold on
errorbar(1:24,mean1,SEM1,'LineWidth',1.5,'LineStyle','None','Color','#0072BD');

p2 = plot(1:24,mean2,'LineWidth',1.5,'Color','#D95319');
errorbar(1:24,mean2,SEM2,'LineWidth',1.5,'LineStyle','None','Color','#D95319');

if list3 ~= "None"
    p3 = plot(1:24,mean3,'LineWidth',1.5,'Color','#EDB120');
    errorbar(1:24,mean3,SEM3,'LineWidth',1.5,'LineStyle','None','Color','#EDB120');
end

if list4 ~= "None"
    p4 = plot(1:24,mean4,'LineWidth',1.5,'Color','#7E2F8E');
    errorbar(1:24,mean4,SEM4,'LineWidth',1.5,'LineStyle','None','Color','#7E2F8E');
end

if list5 ~= "None"
    p5 = plot(1:24,mean5,'LineWidth',1.5,'Color','#77AC30');
    errorbar(1:24,mean5,SEM5,'LineWidth',1.5,'LineStyle','None','Color','#77AC30');
end

if list6 ~= "None"
    p6 = plot(1:24,mean6,'LineWidth',1.5,'Color','#4DBEEE');
    errorbar(1:24,mean6,SEM6,'LineWidth',1.5,'LineStyle','None','Color','#4DBEEE');
end

xlabel('Zeitgeber Time (h)', 'FontSize', 16);
ylabel(strcat('Normalized',{' '},sleepState,' Delta Power'), 'FontSize', 16);
xlim([0,24.5]);
%ylim([1.3,6.3]);       % Can set y-limit here if you want it to be equal across graphs
xticks(0:24)
ylim tight
title(strcat(graphTitle,{' '},sleepState), 'FontSize', 22)

yLimit = get(gca,'YLim');
x = [0 12 12 0];
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'y','FaceAlpha',0.1)
x = [12 24.5 24.5 12];
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'k','FaceAlpha',0.1)

if 0 == contains(graphTitle,["baseline","Baseline","recovery","Recovery"])
    x = [1 5 5 1];
    y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
    patch(x,y,'r','FaceAlpha',0.1)
end

if list6 ~= "None"
    legend([p1 p2 p3 p4 p5 p6], legendNames, 'FontSize', 16)
elseif list5 ~= "None"
    legend([p1 p2 p3 p4 p5], legendNames, 'FontSize', 16)
elseif list4 ~= "None"
    legend([p1 p2 p3 p4], legendNames, 'FontSize', 16)    
elseif list3 ~= "None"
    legend([p1 p2 p3], legendNames, 'FontSize', 16)
elseif list3 == "None"
    legend([p1 p2], legendNames, 'FontSize', 16) 
end

saveas(gcf, strcat(graphTitle,{' '},sleepState,'.png'))

%close all              % Can turn this on if you want the graph to close after being produced
