%% Plot_iRobotData
%
%% Housekeeping
clc; 
close all;
clear D1* D2* D3* D4* Data*
%% Init
iRobot_filename = 'test_drive_foam0_2G_10_17_r1.csv';
SaveSummaryFlg = 0;
%     case 'test_drive_foam0_10_17_r1.csv'
%     case 'test_drive_foam0_10_17_r2.csv'
%     case 'test_drive_foam1_10_17_r1.csv'
%     case 'test_drive_foam1_10_17_r2.csv'
%     case 'test_drive_foam2_10_17_r1.csv'
%     case 'test_drive_foam2_10_17_r2.csv'
%     case 'test_drive_foam0_2G_10_17_r1.csv'
%     case 'test_drive_foam0_2G_10_17_r2.csv'

Grav            = 32.17;
A_Threshold_g   = 0.1;
% Plot Options
LW = 1.5;
Pos = [821-500 793-500 886 616];

switch iRobot_filename
    case 'test_drive_foam0_10_17_r1.csv'
        Data_StartStop_i  = [1, 2797];
        D1_StartStop_sec = [4.971, 17.16];
        D2_StartStop_sec = [21.1, 32.68];
        D3_StartStop_sec = [37.67, 44.32];
        D4_StartStop_sec = [48.59, 54.17];
    case 'test_drive_foam0_10_17_r2.csv'
        Data_StartStop_i  = [1, 4687];
        D1_StartStop_sec = [2.382, 14.77];
        D2_StartStop_sec = [32.26, 44.07];
        D3_StartStop_sec = [48.76, 55.51];
        D4_StartStop_sec = [83.9, 90.55];
    case 'test_drive_foam1_10_17_r1.csv'
        Data_StartStop_i  = [1, 3306];
        D1_StartStop_sec = [7.328, 19.8];
        D2_StartStop_sec = [25.41, 37.16];
        D3_StartStop_sec = [43.33, 49.24];
        D4_StartStop_sec = [52.96, 58.49];
    case 'test_drive_foam1_10_17_r2.csv'
        Data_StartStop_i  = [1, 3229];
        D1_StartStop_sec = [3.88, 16];
        D2_StartStop_sec = [22.2, 34.05];
        D3_StartStop_sec = [41.68, 48.48];
        D4_StartStop_sec = [53.66, 60.04];
    case 'test_drive_foam2_10_17_r1.csv'
        Data_StartStop_i  = [1, 3155];
        D1_StartStop_sec = [10.1, 22.3];
        D2_StartStop_sec = [28.48, 37.46];
        D3_StartStop_sec = [43.89, 50.74];
        D4_StartStop_sec = [56.3, 61.78];
    case 'test_drive_foam2_10_17_r2.csv'
        Data_StartStop_i  = [1, 2737];
        D1_StartStop_sec = [1.82, 14.4];
        D2_StartStop_sec = [16.65, 28.6];
        D3_StartStop_sec = [33.22, 40.2];
        D4_StartStop_sec = [45.7, 52.25];
    case 'test_drive_foam0_2G_10_17_r1.csv'
        Data_StartStop_i  = [1, 3833];
        D1_StartStop_sec = [3.42, 16.1];
        D2_StartStop_sec = [29.42, 41.4];
        D3_StartStop_sec = [50.2, 57.1];
        D4_StartStop_sec = [67.42, 73.88];
    case 'test_drive_foam0_2G_10_17_r2.csv'
        Data_StartStop_i  = [1, 3213];
        D1_StartStop_sec = [3.31, 15.56];
        D2_StartStop_sec = [23.6, 35.3];
        D3_StartStop_sec = [45.27, 52.2];
        D4_StartStop_sec = [61.5, 66.09];
    otherwise
        Data_StartStop_i  = [1, 3364];
        D1_StartStop_sec = [1 2];
        D2_StartStop_sec = [1 2];
        D3_StartStop_sec = [1 2];
        D4_StartStop_sec = [1 2];
end

%% Load Data
% Raw Data
RawData = xlsread(iRobot_filename, iRobot_filename(1:(end-4)), ...
                    ['A' num2str(Data_StartStop_i(1)) ':G' num2str(Data_StartStop_i(2))]);
% Time
Data.Time_sec = RawData(:,1);
Data.dTime_sec = Data.Time_sec - Data.Time_sec(1);
% Gyros
Data.P_dps = RawData(:,2);
Data.Q_dps = RawData(:,3);
Data.R_dps = RawData(:,4);
% Accelerometer
Data.Ax_g = RawData(:,5);
Data.Ay_g = RawData(:,6);
Data.Az_g = RawData(:,7);

%% Calculations
% Integration
Data.Vx_fps     = zeros(size(Data.Ax_g));
Data.Vy_fps     = zeros(size(Data.Ax_g));
Data.Vz_fps     = zeros(size(Data.Ax_g));

Data.Px_ft     = zeros(size(Data.Ax_g));
Data.Py_ft     = zeros(size(Data.Ax_g));
Data.Pz_ft     = zeros(size(Data.Ax_g));

for ii = 2:length(Data.Ax_g)
    
    Data.Vx_fps(ii) = Data.Vx_fps(ii-1) + 1*Data.Ax_g(ii-1)*Grav*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1));
    Data.Vy_fps(ii) = Data.Vy_fps(ii-1) + 1*Data.Ay_g(ii-1)*Grav*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1));
    Data.Vz_fps(ii) = Data.Vz_fps(ii-1) + 1*(Data.Az_g(ii-1)-1)*Grav*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1)); % adjust for gravity
    
    Data.Px_ft(ii) = Data.Px_ft(ii-1) + Data.Vx_fps(ii-1)*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1));
    Data.Py_ft(ii) = Data.Py_ft(ii-1) + Data.Vy_fps(ii-1)*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1));
    Data.Pz_ft(ii) = Data.Pz_ft(ii-1) + Data.Vz_fps(ii-1)*(Data.dTime_sec(ii) - Data.dTime_sec(ii-1));
    
end

imin = find((Data.dTime_sec >= D1_StartStop_sec(1)),1,'first');
imax = find((Data.dTime_sec <= D1_StartStop_sec(2)),1,'last');
D1_index = imin:imax;
imin = find((Data.dTime_sec >= D2_StartStop_sec(1)),1,'first');
imax = find((Data.dTime_sec <= D2_StartStop_sec(2)),1,'last');
D2_index = imin:imax;
imin = find((Data.dTime_sec >= D3_StartStop_sec(1)),1,'first');
imax = find((Data.dTime_sec <= D3_StartStop_sec(2)),1,'last');
D3_index = imin:imax;
imin = find((Data.dTime_sec >= D4_StartStop_sec(1)),1,'first');
imax = find((Data.dTime_sec <= D4_StartStop_sec(2)),1,'last');
D4_index = imin:imax;

D1_Summary.Ax_max  = max(Data.Ax_g(D1_index));
D1_Summary.Ax_min  = min(Data.Ax_g(D1_index));
D1_Summary.Ax_mean = mean(Data.Ax_g(D1_index));
D1_Summary.Ax_abs_mean = mean(abs(Data.Ax_g(D1_index)));

D1_Summary.Ay_max  = max(Data.Ay_g(D1_index));
D1_Summary.Ay_min  = min(Data.Ay_g(D1_index));
D1_Summary.Ay_mean = mean(Data.Ay_g(D1_index));
D1_Summary.Ay_abs_mean = mean(abs(Data.Ay_g(D1_index)));

D1_Summary.Az_max  = max(Data.Az_g(D1_index)-1);
D1_Summary.Az_min  = min(Data.Az_g(D1_index)-1);
D1_Summary.Az_mean = mean((Data.Az_g(D1_index)-1));
D1_Summary.Az_abs_mean = mean(abs(Data.Az_g(D1_index)-1));

D2_Summary.Ax_max  = max(Data.Ax_g(D2_index));
D2_Summary.Ax_min  = min(Data.Ax_g(D2_index));
D2_Summary.Ax_mean = mean(Data.Ax_g(D2_index));
D2_Summary.Ax_abs_mean = mean(abs(Data.Ax_g(D2_index)));

D2_Summary.Ay_max  = max(Data.Ay_g(D2_index));
D2_Summary.Ay_min  = min(Data.Ay_g(D2_index));
D2_Summary.Ay_mean = mean(Data.Ay_g(D2_index));
D2_Summary.Ay_abs_mean = mean(abs(Data.Ay_g(D2_index)));

D2_Summary.Az_max  = max(Data.Az_g(D2_index)-1);
D2_Summary.Az_min  = min(Data.Az_g(D2_index)-1);
D2_Summary.Az_mean = mean((Data.Az_g(D2_index)-1));
D2_Summary.Az_abs_mean = mean(abs(Data.Az_g(D2_index)-1));

D3_Summary.Ax_max  = max(Data.Ax_g(D3_index));
D3_Summary.Ax_min  = min(Data.Ax_g(D3_index));
D3_Summary.Ax_mean = mean(Data.Ax_g(D3_index));
D3_Summary.Ax_abs_mean = mean(abs(Data.Ax_g(D3_index)));

D3_Summary.Ay_max  = max(Data.Ay_g(D3_index));
D3_Summary.Ay_min  = min(Data.Ay_g(D3_index));
D3_Summary.Ay_mean = mean(Data.Ay_g(D3_index));
D3_Summary.Ay_abs_mean = mean(abs(Data.Ay_g(D3_index)));

D3_Summary.Az_max  = max(Data.Az_g(D3_index)-1);
D3_Summary.Az_min  = min(Data.Az_g(D3_index)-1);
D3_Summary.Az_mean = mean((Data.Az_g(D3_index)-1));
D3_Summary.Az_abs_mean = mean(abs(Data.Az_g(D3_index)-1));

D4_Summary.Ax_max  = max(Data.Ax_g(D4_index));
D4_Summary.Ax_min  = min(Data.Ax_g(D4_index));
D4_Summary.Ax_mean = mean(Data.Ax_g(D4_index));
D4_Summary.Ax_abs_mean = mean(abs(Data.Ax_g(D4_index)));

D4_Summary.Ay_max  = max(Data.Ay_g(D4_index));
D4_Summary.Ay_min  = min(Data.Ay_g(D4_index));
D4_Summary.Ay_mean = mean(Data.Ay_g(D4_index));
D4_Summary.Ay_abs_mean = mean(abs(Data.Ay_g(D4_index)));

D4_Summary.Az_max  = max(Data.Az_g(D4_index)-1);
D4_Summary.Az_min  = min(Data.Az_g(D4_index)-1);
D4_Summary.Az_mean = mean((Data.Az_g(D4_index)-1));
D4_Summary.Az_abs_mean = mean(abs(Data.Az_g(D4_index)-1));

if SaveSummaryFlg
    saveStr = ['save Summary_' iRobot_filename(1:(end-4)) ' D1* D2* D3* D4* Data'];
    eval(saveStr)
end

%% Plots
%% Time
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Data.dTime_sec,Data.dTime_sec, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Time Data'}, 'FontWeight', 'bold')
ylabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Data.dTime_sec(2:end),diff(Data.dTime_sec), 'b.', 'LineWidth',LW)
hold on; grid on;
ylabel('Time Step', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Gyros
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.P_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Raw Gyro Data: PQR'}, 'FontWeight', 'bold')
ylabel('P [deg/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Q_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Q [deg/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.R_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('R [deg/sec]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Accel
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.Ax_g, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Raw Acceleration Data: Axyz'}, 'FontWeight', 'bold')
ylabel('Ax [Gs]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([-0.2 0.2])

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Ay_g, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Ay [Gs]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([-0.2 0.2])

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Az_g, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Az [Gs]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([0.8 1.2])

linkaxes(ax,'x')

%% Vel
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.Vx_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Velocity Data: Vxyz'}, 'FontWeight', 'bold')
ylabel('Vx [ft/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Vy_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Vy [ft/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Vz_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Vz [ft/sec]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Pos
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.Px_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Positon Data: Pxyz'}, 'FontWeight', 'bold')
ylabel('Px [ft]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Py_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Py [ft]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Pz_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Pz [ft]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% X Axis
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.Ax_g*Grav, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'X-Axis Data'}, 'FontWeight', 'bold')
ylabel('Ax [ft/sec^2]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Vx_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Vx [ft/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Px_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Px [ft]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Y Axis
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,Data.Ay_g*Grav, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Y-Axis Data'}, 'FontWeight', 'bold')
ylabel('Ay [ft/sec^2]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Vy_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Vy [ft/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Py_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Py [ft]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Z Axis
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Data.dTime_sec,(Data.Az_g-1)*Grav, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Z-Axis Data'}, 'FontWeight', 'bold')
ylabel('Az (w/Gravity) [ft/sec^2]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Data.dTime_sec,Data.Vz_fps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Vz [ft/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Data.dTime_sec,Data.Pz_ft, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Pz [ft]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')