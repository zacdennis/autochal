% EUL2QUATERNION Converts Euler Angles to a Quaternion Vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul2quaternion:
%     Converts the euler angles (phi, theta, and psi) to a quaternion 
%     vector. 
% 
% SYNTAX:
%	[quat] = eul2quaternion(euler_rad)
%
% INPUTS: 
%	Name		Size            Units	Description
%	euler_rad	[1x3] or [3x1]	[rad]   Euler angles phi, theta, and psi.
%
% OUTPUTS: 
%	Name		Size            Units	Description
%	quat		[1x4] or [4x1]  [ND]   	Quaternions [q1, q2, q3, q4]
%                                       Note: q4 is the scalar
%
% NOTES:
%
% EXAMPLES:
%	Example 1: Simple Transformation
%	A single call of the euler to quaternion function. 
%   quat = eul2quaternion([pi pi/2 0])
%	Return quat =[ 0.7071    0.0000   -0.7071    0.0000]
%
%	Example 2: Transform and back
%	[quat] = eul2quaternion(euler_rad)
%	Returns 
%
% SOURCE DOCUMENTATION:
%   [1]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%   Simulation. 2nd Edition" New York: John Wiley & Sons, Inc. 2003.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul2quaternion.m">eul2quaternion.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_eul2quaternion.m">DRIVER_eul2quaternion.m</a>
%	  Documentation: <a href="matlab:winopen(which('eul2quaternion_Function_Documentation.pptx'));">eul2quaternion_Function_Documentation.pptx</a>
%
% See also quat2eul
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/340
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul2quaternion.m $
% $Rev: 3172 $
% $Date: 2014-05-14 12:54:29 -0500 (Wed, 14 May 2014) $
% $Author: sufanmi $

function [quat] = eul2quaternion(euler_rad)
%#codegen

if(size(euler_rad, 1) > 1)
    quat = zeros(4,1);
else
    quat = zeros(1,4);
end

%% Initialize Outputs:
phi2    = euler_rad(1)/2;   % [rad]
theta2  = euler_rad(2)/2;   % [rad]
psi2    = euler_rad(3)/2;   % [rad]

%% Main Function:
%  Ref 1, pg 32 (1.3-33) Note that q4 is q0
q1 = sin(phi2) * cos(theta2) * cos(psi2) - cos(phi2) * sin(theta2) * sin(psi2);
q2 = cos(phi2) * sin(theta2) * cos(psi2) + sin(phi2) * cos(theta2) * sin(psi2);
q3 = cos(phi2) * cos(theta2) * sin(psi2) - sin(phi2) * sin(theta2) * cos(psi2);
q4 = cos(phi2) * cos(theta2) * cos(psi2) + sin(phi2) * sin(theta2) * sin(psi2);

%% Outputs:
quat(1) = q1;
quat(2) = q2;
quat(3) = q3;
quat(4) = q4;

end % << End of function eul2quaternion >>

%% REVISION HISTORY
% YYMMDD INI: note
% 131029 MWS: Added ability to return quat will same dimensions (either row
%               or column vector) as euler.
% 101103 JPG: Changed some error correction to allow [3x1] and [1x3] input.
% 100907 JPG: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
