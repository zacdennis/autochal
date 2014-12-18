% LEVELTURN_PSIDOT2PHI Computes level flight roll angle as a function of turn rate
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LevelTurn_PsiDot2Phi:
%     Computes level flight roll angle as a function of turn rate
% 
% SYNTAX:
%	[Phi_ned_deg] = LevelTurn_PsiDot2Phi(PsiDot_ned_dps, Vtas, Gmag)
%
% INPUTS: 
%	Name            Size		Units           Description
%	PsiDot_ned_dps	[1]         [deg/sec]       Turn Rate
%	Vtas            [1]         [length/sec]    True Airspeed
%	Gmag            [1]         [length/sec^2]  Magnitude of Gravity
%
% OUTPUTS: 
%	Name            Size		Units           Description
%	Phi_ned_deg     [1]         [deg]           Bank Angle
%
% NOTES:
%	'Vtas' and 'Gmag' need to carry the same units (either English or
%	Metric).  If English, 'Vtas' will be in [ft/sec] and 'Gmag' will be in
%	[ft/sec^2].  If Metric, 'Vtas' will be [m/sec] and 'Gmag' will be
%	[m/sec^2].
%
% EXAMPLES:
%	% Example #1:
%   PsiDot_ned_dps = 3;     % [deg/sec] Standard Rate Turn
%   Vtas = 100;             % [ft/sec]
%   Gmag = 32.174;          % [ft/sec^2]
%	Phi_ned_deg = LevelTurn_PsiDot2Phi(PsiDot_ned_dps, Vtas, Gmag)
%   % Returns 9.2433 [deg]
%
%   % Recover PsiDot_ned_dps
%   PsiDot_ned_dps2 = LevelTurn_Phi2PsiDot(Phi_ned_deg, Vtas, Gmag)
%   Delta = PsiDot_ned_dps - PsiDot_ned_dps2
%
% SOURCE DOCUMENTATION:
% [1]   Roskam, Jan. Airplane Flight Dynamisc and Automatic Flight
%       Controls, Part I.  Design, Analysis and Reserach Corporation:
%       Lawrence, KS. Copyright 2003.  Equation 4.90, pg 226.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit LevelTurn_PsiDot2Phi.m">LevelTurn_PsiDot2Phi.m</a>
%	  Driver script: <a href="matlab:edit Driver_LevelTurn_PsiDot2Phi.m">Driver_LevelTurn_PsiDot2Phi.m</a>
%	  Documentation: <a href="matlab:winopen(which('LevelTurn_PsiDot2Phi_Function_Documentation.pptx'));">LevelTurn_PsiDot2Phi_Function_Documentation.pptx</a>
%
% See also LevelTurn_Phi2PsiDot 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/850
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/LevelTurn_PsiDot2Phi.m $
% $Rev: 3200 $
% $Date: 2014-05-30 14:41:04 -0500 (Fri, 30 May 2014) $
% $Author: sufanmi $

function [Phi_ned_deg] = LevelTurn_PsiDot2Phi(PsiDot_ned_dps, Vtas, Gmag)

%%
R2D = 180.0/acos(-1);
D2R = 1/R2D;

tanPhi = Vtas * (PsiDot_ned_dps * D2R) / Gmag;
Phi_ned_deg = atan(tanPhi) * R2D;

end % << End of function LevelTurn_PsiDot2Phi >>

%% AUTHOR IDENTIFACATION
% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username 
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
