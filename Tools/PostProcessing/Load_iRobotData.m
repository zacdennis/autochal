% Load_iRobotData loads data recorded on the iRobot
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
%
% SYNTAX:
%   [Results] = Load_iRobotData(loadFilename)
%
% INPUTS: TODO
% OUTPUTS: TODO
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/AutonomyChallenge/trunk/Tools/PostProcessing/Load_iRobotData.m $
% $Rev: 15 $
% $Date: 2014-11-03 15:59:53 -0600 (Mon, 03 Nov 2014) $
% $Author: healypa $

function [Results, iStart] = Load_iRobotData(LoadFilename, strCells)
%% Load Data
% Raw Data
if nargin < 2
    RawData = xlsread(LoadFilename, LoadFilename(1:(end-4)));
    iStart = find(RawData(:,1) == 0, 1, 'last') + 1;
else
    RawData = xlsread(LoadFilename, LoadFilename(1:(end-4)), strCells);
    iStart = 1;
end

% Time
Results.Time_sec = RawData(iStart:end,1);
Results.dTime_sec = Results.Time_sec - Results.Time_sec(1);
% Gyros
Results.P_dps = RawData(iStart:end,2);
Results.Q_dps = RawData(iStart:end,3);
Results.R_dps = RawData(iStart:end,4);
% Accelerometer
Results.Ax_g = RawData(iStart:end,5);
Results.Ay_g = RawData(iStart:end,6);
Results.Az_g = RawData(iStart:end,7);
% Euler Angles
Results.Phi_deg  = RawData(iStart:end,8);
Results.Theta_deg = RawData(iStart:end,9);
Results.Psi_deg   = RawData(iStart:end,10);
% PnPe
Results.Pn_mm = RawData(iStart:end,11);
Results.Pe_mm = RawData(iStart:end,12);
% VnVe
Results.Vn_mmps = RawData(iStart:end,13);
Results.Ve_mmps = RawData(iStart:end,14);
% Heading
Results.Heading_deg = RawData(iStart:end,15);
% WP_count
Results.WP_count = RawData(iStart:end,16);
% Speed Cmd, Heading Cmd
Results.SpeedCmd_mmps  = RawData(iStart:end,17);
Results.HeadingCmd_deg = RawData(iStart:end,18);
% dist_PnPe
Results.distPnPe_mm = RawData(iStart:end,19);
% Turn Radius Cmd, Wheel Speed Cmd
Results.TurnRadiusCmd_mm = RawData(iStart:end,20);
Results.WheelSpeedCmd_mmps = RawData(iStart:end,21);

%% << End of Function Load_iRobotData.m >>

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