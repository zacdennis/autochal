% PQR2EULERDOT Transforms body rates to inertial frame rates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PQR2EulerDot:
%   Transforms body rates to inertial frame rates 
% 
% SYNTAX:
%	[EulerDot_rps] = PQR2EulerDot(Euler_rad, PQR_rps)
%
% INPUTS: 
%	Name            Size	Units		Description
%	Euler_rad       [3]     [rad]       Euler angles w.r.t. inertial frame
%	PQR_rps         [3]     [rad/sec]   Body rates
%
% OUTPUTS: 
%	Name        	Size	Units		Description
%	EulerDot_rps	[3]     [rad/sec]   Euler angle rates w.r.t. inertial frame
%
% NOTES:
%	Body axis are Roll (P), Pitch (Q) and Yaw(R)
%
% EXAMPLES:
%   % Example #1: Covert a body rates to inertial and back
%   Euler_rad = [1 2 3];
%   PQR_rps   = [4 5 6];
%	[EulerDot_rps] = PQR2EulerDot(Euler_rad, PQR_rps)
%   [PQR2_rps] = EulerDot2PQR(Euler_rad, EulerDot_rps)
%   delta_PQR_rps = PQR2_rps - PQR_rps
%
% SOURCE DOCUMENTATION:
% [1]   Kalviste, Juri. Flight Dynamics Reference Handbook. Northrop Corporation Aircraft Division, April 1988. rev.06-30-89.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PQR2EulerDot.m">PQR2EulerDot.m</a>
%	  Driver script: <a href="matlab:edit Driver_PQR2EulerDot.m">Driver_PQR2EulerDot.m</a>
%	  Documentation: <a href="matlab:winopen(which('PQR2EulerDot_Function_Documentation.pptx'));">PQR2EulerDot_Function_Documentation.pptx</a>
%
% See also EulerDot2PQR 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/796
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/PQR2EulerDot.m $
% $Rev: 2906 $
% $Date: 2013-02-25 13:44:53 -0600 (Mon, 25 Feb 2013) $
% $Author: sufanmi $

function [EulerDot_rps] = PQR2EulerDot(Euler_rad, PQR_rps)

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

P_rps       = PQR_rps(1);       % [rad/sec]
Q_rps       = PQR_rps(2);       % [rad/sec]
R_rps       = PQR_rps(3);       % [rad/sec]

% Initialize Output, have EulerDot carry same dimensions as Euler
EulerDot_rps = Euler_rad * 0;
EulerDot_rps(1) = P_rps + tan(Theta_rad)*( Q_rps*sin(Phi_rad) + R_rps*cos(Phi_rad) );
EulerDot_rps(2) = Q_rps*cos(Phi_rad) - R_rps*sin(Phi_rad);
EulerDot_rps(3) = sec(Theta_rad)*( Q_rps*sin(Phi_rad) + R_rps*cos(Phi_rad) );

end % << End of function PQR2EulerDot >>

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
