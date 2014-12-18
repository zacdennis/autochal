%% Plot_iRobotData
%
%% Housekeeping
clc; 
close all;
clear D1* D2* D3* D4* Data
%% Init
iRobot_filenames = {'Summary_test_drive_foam0_10_17_r1.mat',...
                   'Summary_test_drive_foam0_10_17_r2.mat',...
                   'Summary_test_drive_foam1_10_17_r1.mat',...
                   'Summary_test_drive_foam1_10_17_r2.mat',...
                   'Summary_test_drive_foam2_10_17_r1.mat',...
                   'Summary_test_drive_foam2_10_17_r2.mat',...
                   'Summary_test_drive_foam0_2G_10_17_r1.mat', ...
                   'Summary_test_drive_foam0_2G_10_17_r2.mat'};

xls_filename = 'DriveAccelSummary.xlsx';  
xls_sheet    = 'Sheet2';    

%% Summary Matrix      
Drive1Summary = zeros(3,length(iRobot_filenames));

for ii = 1:length(iRobot_filenames)
    load(iRobot_filenames{ii})
    
    Drive1Summary(1:3,ii) = [D1_Summary.Ax_abs_mean; D1_Summary.Ay_abs_mean; D1_Summary.Az_abs_mean];
    Drive2Summary(1:3,ii) = [D2_Summary.Ax_abs_mean; D2_Summary.Ay_abs_mean; D2_Summary.Az_abs_mean];
    Drive3Summary(1:3,ii) = [D3_Summary.Ax_abs_mean; D3_Summary.Ay_abs_mean; D3_Summary.Az_abs_mean];
    Drive4Summary(1:3,ii) = [D4_Summary.Ax_abs_mean; D4_Summary.Ay_abs_mean; D4_Summary.Az_abs_mean];
    
end
  
xlswrite(xls_filename, Drive1Summary, xls_sheet, 'C5');
xlswrite(xls_filename, Drive2Summary, xls_sheet, 'C11');
xlswrite(xls_filename, Drive3Summary, xls_sheet, 'C17');
xlswrite(xls_filename, Drive4Summary, xls_sheet, 'C23');
