% LEVELTURN_PHI2PSIDOT Computes level flight turn rate as a function of roll angle
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LevelTurn_Phi2PsiDot:
%     Computes level flight turn rate as a function of roll angle 
% 
% SYNTAX:
%	[PsiDot_ned_dps] = LevelTurn_Phi2PsiDot(Phi_ned_deg, Vtas, Gmag)
%
% INPUTS: 
%	Name            Size		Units           Description
%	Phi_ned_deg     [1]         [deg]           Bank Angle
%	Vtas            [1]         [length/sec]    True Airspeed
%	Gmag            [1]         [length/sec^2]  Magnitude of Gravity
%
% OUTPUTS: 
%	Name            Size		Units           Description
%	PsiDot_ned_dps	[1]         [deg/sec]       Turn Rate
%
% NOTES:
%	'Vtas' and 'Gmag' need to carry the same units (either English or
%	Metric).  If English, 'Vtas' will be in [ft/sec] and 'Gmag' will be in
%	[ft/sec^2].  If Metric, 'Vtas' will be [m/sec] and 'Gmag' will be
%	[m/sec^2].
%
% EXAMPLES:
%	% Example #1:
%   Phi_ned_deg = 30;       % [deg/sec] Standard Rate Turn
%   Vtas = 100;             % [ft/sec]
%   Gmag = 32.174;          % [ft/sec^2]
%   PsiDot_ned_dps = LevelTurn_Phi2PsiDot(Phi_ned_deg, Vtas, Gmag)
%   % Returns 3.5477 [deg/sec]
%
%   % Recover Phi_ned_deg
%   Phi_ned_deg2 = LevelTurn_PsiDot2Phi(PsiDot_ned_dps, Vtas, Gmag)
%   Delta = Phi_ned_deg - Phi_ned_deg2
%
% SOURCE DOCUMENTATION:
% [1]   Roskam, Jan. Airplane Flight Dynamisc and Automatic Flight
%       Controls, Part I.  Design, Analysis and Reserach Corporation:
%       Lawrence, KS. Copyright 2003.  Equation 4.90, pg 226.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit LevelTurn_Phi2PsiDot.m">LevelTurn_Phi2PsiDot.m</a>
%	  Driver script: <a href="matlab:edit Driver_LevelTurn_Phi2PsiDot.m">Driver_LevelTurn_Phi2PsiDot.m</a>
%	  Documentation: <a href="matlab:winopen(which('LevelTurn_Phi2PsiDot_Function_Documentation.pptx'));">LevelTurn_Phi2PsiDot_Function_Documentation.pptx</a>
%
% See also LevelTurn_PsiDot2Phi
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/<TicketNumber>
%  
% Copyright Northrop Grumman Corp 2014
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/LevelTurn_Phi2PsiDot.m $
% $Rev: 3200 $
% $Date: 2014-05-30 14:41:04 -0500 (Fri, 30 May 2014) $
% $Author: sufanmi $

function [PsiDot_ned_dps] = LevelTurn_Phi2PsiDot(Phi_ned_deg, Vtas, Gmag)

%%
small_val = 1e-10;
R2D = 180.0/acos(-1);
D2R = 1/R2D;

PsiDot_ned_dps = 0;     % Initialize Outputs
if(abs(Vtas) > small_val)
    PsiDot_ned_dps = ((Gmag * tan(Phi_ned_deg * D2R))/Vtas) * R2D;
end

end % << End of function LevelTurn_Phi2PsiDot >>

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
