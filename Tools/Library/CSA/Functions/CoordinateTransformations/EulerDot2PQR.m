% EULERDOT2PQR Transforms inertial frame rates to body rates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% EulerDot2PQR:
%   Transforms inertial frame rates to body rates
% 
% SYNTAX:
%	[PQR_rps] = EulerDot2PQR(Euler_rad, EulerDot_rps)
%
% INPUTS: 
%	Name            Size	Units		Description
%	Euler_rad       [3]     [rad]       Euler angles w.r.t. inertial frame
%	EulerDot_rps	[3]     [rad/sec]   Euler angle rates w.r.t. inertial frame
%
% OUTPUTS: 
%	Name        	Size	Units		Description
%	PQR_rps         [3]     [rad/sec]   Body rates
%
% NOTES:
%	Body axis are Roll (P), Pitch (Q) and Yaw(R)
%
% EXAMPLES:
%   % Example #1: Covert a inertial rates to body and back
%   Euler_rad   = [1 2 3];
%   EulerDot_rps= [4 5 6];
%   [PQR_rps] = EulerDot2PQR(Euler_rad, EulerDot_rps)
%	[EulerDot2_rps] = PQR2EulerDot(Euler_rad, PQR_rps)
%   delta_EulerDot_rps = EulerDot2_rps - EulerDot_rps
%
% SOURCE DOCUMENTATION:
% [1]   Kalviste, Juri. Flight Dynamics Reference Handbook. Northrop Corporation Aircraft Division, April 1988. rev.06-30-89.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit EulerDot2PQR.m">EulerDot2PQR.m</a>
%	  Driver script: <a href="matlab:edit Driver_EulerDot2PQR.m">Driver_EulerDot2PQR.m</a>
%	  Documentation: <a href="matlab:winopen(which('EulerDot2PQR_Function_Documentation.pptx'));">EulerDot2PQR_Function_Documentation.pptx</a>
%
% See also PQR2EulerDot 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/795
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/EulerDot2PQR.m $
% $Rev: 2906 $
% $Date: 2013-02-25 13:44:53 -0600 (Mon, 25 Feb 2013) $
% $Author: sufanmi $

function [PQR_rps] = EulerDot2PQR(Euler_rad, EulerDot_rps)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Main Function:
Phi_rad     = Euler_rad(1);     % [rad]
Theta_rad   = Euler_rad(2);     % [rad]

PhiDot_rps  = EulerDot_rps(1);  % [rad/sec]
ThetaDot_rps= EulerDot_rps(2);  % [rad/sec]
PsiDot_rps  = EulerDot_rps(3);  % [rad/sec]

% Initialize Output, have PQR carry same dimensions as Euler
PQR_rps = Euler_rad * 0;
PQR_rps(1) = PhiDot_rps - PsiDot_rps * sin(Theta_rad);                                  % [rad/sec] P
PQR_rps(2) = PsiDot_rps * sin(Phi_rad) * cos(Theta_rad) + ThetaDot_rps * cos(Phi_rad);  % [rad/sec] Q
PQR_rps(3) = PsiDot_rps * cos(Phi_rad) * cos(Theta_rad) - ThetaDot_rps * sin(Phi_rad);  % [rad/sec] R

end % << End of function EulerDot2PQR >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130225 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
