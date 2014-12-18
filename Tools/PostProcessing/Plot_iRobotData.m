% plot_iRobotData plots data recorded on the iRobot
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/AutonomyChallenge/trunk/Tools/PostProcessing/Plot_iRobotData.m $
% $Rev: 38 $
% $Date: 2014-11-17 14:34:54 -0600 (Mon, 17 Nov 2014) $
% $Author: healypa $
%% Housekeeping
clc;
% close all;

%% Init
LoadFilename = 'MainOut_WP_Center_Laps5_r2.csv';
[Results, iStart] = Load_iRobotData(LoadFilename);%, strCells);

% Plot Options
LW = 1.5;
Pos = [821-500 793-500 886 616];

%% Plots
%% Time
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Results.dTime_sec,Results.dTime_sec, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Time Data'}, 'FontWeight', 'bold')
ylabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Results.dTime_sec(2:end),diff(Results.dTime_sec), 'b.', 'LineWidth',LW)
hold on; grid on;
ylabel('Time Step', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Position
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Results.dTime_sec,Results.Pn_mm/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Position'}, 'FontWeight', 'bold')
ylabel('Pn [m]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Results.dTime_sec,Results.Pe_mm/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Pe [m]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

figure;
set(gcf, 'Position', Pos)
plot(Results.Pe_mm/1000, Results.Pn_mm/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
plot(Results.Pe_mm(1)/1000, Results.Pn_mm(1)/1000, 'go', 'LineWidth',LW)
plot(Results.Pe_mm(end)/1000, Results.Pn_mm(end)/1000, 'rx', 'LineWidth',LW)
ylabel('Pn [m]', 'FontWeight', 'bold')
xlabel('Pe [m]', 'FontWeight', 'bold')
axis('equal')
legend('Position', 'Begin', 'End')

%% Velocity, Heading
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Results.dTime_sec,Results.Vn_mmps/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Velocity, Heading'}, 'FontWeight', 'bold')
ylabel('Vn [m/s]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Results.dTime_sec,Results.Ve_mmps/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Ve [m/s]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Results.dTime_sec,Results.Heading_deg, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Heading [deg]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Gyros
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Results.dTime_sec,Results.P_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Raw Gyro Data: PQR'}, 'FontWeight', 'bold')
ylabel('P [deg/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Results.dTime_sec,Results.Q_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Q [deg/sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Results.dTime_sec,Results.R_dps, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('R [deg/sec]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Euler
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Results.dTime_sec,Results.Phi_deg, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Euler Angles'}, 'FontWeight', 'bold')
ylabel('\phi [deg]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(312);
plot(Results.dTime_sec,Results.Theta_deg, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('\theta [deg]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(3) = subplot(313);
plot(Results.dTime_sec,Results.Psi_deg, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('\psi [deg]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% Accel
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,3);
ax(1) = subplot(311);
plot(Results.dTime_sec,Results.Ax_g, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Raw Acceleration Data: Axyz'}, 'FontWeight', 'bold')
ylabel('Ax [Gs]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([-0.2 0.2])

ax(2) = subplot(312);
plot(Results.dTime_sec,Results.Ay_g, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Ay [Gs]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([-0.2 0.2])

ax(3) = subplot(313);
plot(Results.dTime_sec,Results.Az_g, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Az [Gs]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
ylim([0.8 1.2])

linkaxes(ax,'x')

%% WP Count, dist_PnPe
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Results.dTime_sec,Results.WP_count, 'b-', 'LineWidth',LW)
hold on; grid on;
title({'Waypoint Count & Distance to Target'}, 'FontWeight', 'bold')
ylabel('WP Count [int]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Results.dTime_sec,Results.distPnPe_mm/1000, 'b-', 'LineWidth',LW)
hold on; grid on;
ylabel('Distance to Target [m]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% SpeedCmd, Heading Cmd
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Results.dTime_sec,Results.SpeedCmd_mmps/1000, 'k-', 'LineWidth',LW)
hold on; grid on;
title({'Middle Loop Commands'}, 'FontWeight', 'bold')
ylabel('Speed Cmd [m/s]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Results.dTime_sec,Results.HeadingCmd_deg, 'k-', 'LineWidth',LW)
hold on; grid on;
plot(Results.dTime_sec,Results.Heading_deg, 'b-', 'LineWidth',LW)
ylabel('Heading Cmd [deg]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
legend('Command', 'Actual')
linkaxes(ax,'x')

%% TrunRadiusCmd, WheelSpeedCmd
figure;
set(gcf, 'Position', Pos)
ax = zeros(1,2);
ax(1) = subplot(211);
plot(Results.dTime_sec,Results.TurnRadiusCmd_mm/1000, 'k-', 'LineWidth',LW)
hold on; grid on;
title({'Inner Loop, Actuator Commands'}, 'FontWeight', 'bold')
ylabel('Turn Radius Cmd [m]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');

ax(2) = subplot(212);
plot(Results.dTime_sec,Results.WheelSpeedCmd_mmps/1000, 'k-', 'LineWidth',LW)
hold on; grid on;
ylabel('Wheel Speed Cmd [m/s]', 'FontWeight', 'bold')
xlabel('Time [sec]', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
linkaxes(ax,'x')

%% << End of Function Plot_iRobotResults.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101124 <INI>: Created script created using CreateNewScript
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% <initials>: <Fullname> : <email> : <NGGN username> 

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------