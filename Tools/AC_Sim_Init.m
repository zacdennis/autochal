 % -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AC_Sim_Init.m
%   Initialization Script for Autonomy Challenge tools folder (No simulation exists currently)
%
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/AutonomyChallenge/trunk/Tools/AC_Sim_Init.m $
% $Rev: 11 $
% $Date: 2014-11-03 11:14:40 -0600 (Mon, 03 Nov 2014) $
% $Author: healypa $

%%==================== Simulation Initialization ==========================
%% Housekeeping:
close all; clear all; clc;
clear mex;

%% Ensure that Script Executes in Correct Folder
cd(fileparts(mfilename('fullpath')));

AC_Path_Init;   % Load Paths
conversions;     % Standard Unit Conversions

%% Load Central Body Properties (in ENGLISH):
CentralBody = CentralBodyEarth_init(0);
Ground      = EarthSurfaceInit(0);

%% << End of Script AC_Sim_Init.m >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% <CreateDate> <INI>: Created script created using CreateNewScript
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
