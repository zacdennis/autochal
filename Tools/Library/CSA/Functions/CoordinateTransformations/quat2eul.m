% QUAT2EUL Converts Quaternion Vector to Euler Angles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% quat2eul:
%    Converts Quaternion Vector to Euler Angles
% 
% SYNTAX:
%	[euler_rad] = quat2eul(quat)
%
% INPUTS: 
%	Name		Size            Units		Description
%	 quat       [1x4] or [4x1]  [ND]        Quaternions [q1, q2, q3, q4]
%                                           Note: q4 is the scalar
%
% OUTPUTS: 
%	Name		Size            Units		Description
%	euler_rad   [1x3] or [3x1]  [rad]       Euler Anles [Phi, Theta, Psi]
%
% NOTES:
%	Last term in the quaternion is a scalar(q4). 
%
% EXAMPLES:
%	Example 1:
%	[euler_rad] = quat2eul(quat)
%	Returns
%
%	Example 2:
%	[euler_rad] = quat2eul(quat)
%	Returns
%
% SOURCE DOCUMENTATION:
%   [1]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%   Simulation. 2nd Edition" New York: John Wiley & Sons, Inc. 2003.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit quat2eul.m">quat2eul.m</a>
%	  Driver script: <a href="matlab:edit Driver_quat2eul.m">Driver_quat2eul.m</a>
%	  Documentation: <a href="matlab:winopen(which('quat2eul_Function_Documentation.pptx'));">quat2eul_Function_Documentation.pptx</a>
%
% See also eul2quaternion 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/355
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/quat2eul.m $
% $Rev: 3043 $
% $Date: 2013-10-29 20:26:29 -0500 (Tue, 29 Oct 2013) $
% $Author: sufanmi $

function [euler_rad] = quat2eul(quat)

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
q1  = quat(1);   % [unitless]
q2  = quat(2);   % [unitless]
q3  = quat(3);   % [unitless]
q4  = quat(4);   % [unitless] - Scalar

% [1] Pg 31 (1.4-32) Build coefficients for direction cosine matrix
%     Note that q4 is q0.
c11 = q4^2 + q1^2 - q2^2 - q3^2;
c12 = 2*(q1*q2 + q4*q3);
c13 = 2*(q1*q3 - q4*q2);
c23 = 2*(q2*q3 + q4*q1);
c33 = q4^2 - q1^2 - q2^2 + q3^2;

% [1] Pg 29 (1.3-24) Convertion direction cosine matrix coefficients to
% Euler
phi_rad     = atan2(c23, c33);
theta_rad   = -asin(c13);
psi_rad     = atan2(c12, c11);

euler_rad   = quat(1:3)*0;  % Initialize Output
euler_rad(1)= phi_rad;      % [rad]
euler_rad(2)= theta_rad;
euler_rad(3)= psi_rad;

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 131029 MWS: Added reference documentation.  Fixed output to be of same
%               dimensionality (either row or column) as input.
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/quat2eul.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : G67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

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
