% plot_MagnetometerData plots data recorded on the iRobot
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/AutonomyChallenge/trunk/Tools/PostProcessing/Plot_iRobotData.m $
% $Rev: 17 $
% $Date: 2014-11-06 09:18:51 -0800 (Thu, 06 Nov 2014) $
% $Author: healypa $
%% Housekeeping
clc;
%close all;
clear mag_x mag_y mag_z

%% Init
TestCase = 1;

if(TestCase == 1)
    LoadFilename = 'IMU2_mag_offsets_r1.xlsx';
    mag_x(:,1) = xlsread(LoadFilename, 'magoffsets', 'A2:A1540');
    mag_y(:,1) = xlsread(LoadFilename, 'magoffsets', 'B2:B1540');
    mag_z(:,1) = xlsread(LoadFilename, 'magoffsets', 'C2:C1540');
end

% Plot Options
UseMagOffset = 0;
LW = 1.5;
Pos = [821-500 793-500 886 616];

%% Calculations
mag_x_min  = min(mag_x)
mag_x_max  = max(mag_x)
mag_x_mean = mean(mag_x)

mag_y_min  = min(mag_y)
mag_y_max  = max(mag_y)
mag_y_mean = mean(mag_y)

mag_z_min  = min(mag_z)
mag_z_max  = max(mag_z)
mag_z_mean = mean(mag_z)

mag_x_offset(TestCase) = -(mag_x_max - (mag_x_max-mag_x_min)/2)
mag_y_offset(TestCase) = -(mag_y_max - (mag_y_max-mag_y_min)/2)
mag_z_offset(TestCase) = -(mag_z_max - (mag_z_max-mag_z_min)/2)

%% Plots
%% Time
figure;
set(gcf, 'Position', Pos)
if(UseMagOffset)
    plot3(mag_x + mag_x_offset(TestCase), mag_y + mag_y_offset(TestCase), mag_z + mag_z_offset(TestCase), 'b.', 'LineWidth',LW)
else
    plot3(mag_x, mag_y, mag_z, 'b.', 'LineWidth',LW)
end
hold on; grid on;
plot3([-1000 1000],[0 0], [0 0], 'r-', 'LineWidth',LW)
plot3([0 0],[-1000 1000], [0 0], 'r-', 'LineWidth',LW)
plot3([0 0], [0 0], [-1000 1000],'r-', 'LineWidth',LW)
title({'Magnetometer Data'}, 'FontWeight', 'bold')
xlabel('Mag X', 'FontWeight', 'bold')
xlabel('Mag Y', 'FontWeight', 'bold')
xlabel('Mag Z', 'FontWeight', 'bold')
set(gca, 'FontWeight', 'bold');
axis('equal')

%% << End of Function Plot_MagnetometerResults.m >>

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