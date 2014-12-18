% EUL_NED_2_EUL_I  Converts Euler Angles w.r.t. the North/East/Down Coordinate Frame into the Oblate Central Body Inertial Frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_ned_2_eul_i:
%     Converts Euler Angles w.r.t. the North/East/Down Coordinate Frame into
%     the Oblate Central Body Inertial Frame
% 
% SYNTAX:
%	[Euler_i, body_C_i] = eul_ned_2_eul_i(lat, lon, mst, Euler_ned)
%	
% INPUTS: 
%	Name     	Size              Units		Description
%   lat         [1x1]             [deg]     Geodetic Latitude
%   lon         [1x1]             [deg]     Longitude
%   mst         [1x1]             [deg]     Mean Sidereal Time (celestial longitude)
%   Euler_ned   [3x1] or [1x3]    [deg]     Euler orientation in North East Down Frame
%
% OUTPUTS: 
%	Name     	Size              Units		Description
%	Euler_i     [3x1] or [1x3]    [deg]     Euler orientation in Central Body Inertial 
%                                           Frame
%   body_C_i    [3x3]             [ND]      DCM from Central Body Inertial Frame to 
%                                           Aircraft Body Frame
% NOTES:
%	This function first transforms the euler angles into a direction cosine
%	matrix rotation. This rotation is then propagated to the fixed frame
%	using eul2dcm and later to the NED coordinate system. The function then
%   reverts the process using dcm2eul tor recover the euler angles in the
%   body inertial coordinate frame.
%
% EXAMPLES:
%	Example 1: The coordinates of an aircraft flying over Paris are
%	latitude = 48.5 and longitude = 2.2 degress. If the orientation of the
%	aircraft is [30 45 60] degrees w.r.t to the NED reference frame. Find the orientation 
%   of the aircraft in body inertial coordinates. mst=30. (row vector)
%   lat=48.5; lon=2.2; mst=30; Euler_ned=[30 45 60];
% 	[Euler_i, body_C_i] = eul_ned_2_eul_i(lat, lon, mst, Euler_ned)
%	Returns Euler_i =[ -87.2319  -49.8060  103.7968 ]
%          body_C_i =[  -0.1539    0.6268    0.7639
%                       -0.2289    0.7294   -0.6446
%                       -0.9612   -0.2740    0.0312 ]
%
%	Example 2: The coordinates of a spacecraft flying over New York are
%	latitude = 40.4 and longitude = -74.0 (west) degress. If the orientation of the
%	aircraft is [20 40 90] degrees w.r.t to NED coordinate system. Find the orientation 
%   of the aircraft in body inertial coordinates. mst=45. (Column vector)
%   lat=40.4; lon=-74.0; mst=45; Euler_ned=[20; 40; 90];
% 	[Euler_i, body_C_i] = eul_ned_2_eul_i(lat, lon, mst, Euler_ned)
%   Returns Euler_i =[ -103.1025; -24.6203; 28.4212 ]
%          body_C_i =[    0.7995    0.4327    0.4166
%                         0.4647   -0.0063   -0.8854
%                        -0.3805    0.9015   -0.2061 ]
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_ned_2_eul_i.m">eul_ned_2_eul_i.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_ned_2_eul_i.m">Driver_eul_ned_2_eul_i.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_ned_2_eul_i_Function_Documentation.pptx');">eul_ned_2_eul_i_Function_Documentation.pptx</a>
%
% See also eul_i_2_eul_ned 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/336
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_ned_2_eul_i.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Euler_i, body_C_i] = eul_ned_2_eul_i(lat, lon, mst, Euler_ned)

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

%% Input Check
if ischar(lat)||ischar(lon)||ischar(Euler_ned)|| ischar(mst)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(Euler_ned, 1) ~= 3)&&(size(Euler_ned, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Size of Euler angles must be [1x3] or [3x1]! See ' mlink ' documentation for help.']);
end
%% Main Function:
%% Conversions
d2r = pi/180;
r2d = 180/pi;

%% Compute Direction Cosine Matrices:
% Inertial to Fixed:
rotI2F = [0; 0; mst] * d2r;         % [rad]
f_C_i = eul2dcm(rotI2F);

% Fixed to LLA:
rotF2LLA = [0; -lat; lon] * d2r;    % [rad]
lla_C_f = eul2dcm(rotF2LLA);

% LLA to North East Down:
rotLLA2NED = [0; -90; 0] * d2r;     % [rad]
ned_C_lla = eul2dcm(rotLLA2NED);

% North East Down to Body:
body_C_ned = eul2dcm(Euler_ned * d2r);

% Inertial to Body:
body_C_i = body_C_ned * ned_C_lla * lla_C_f * f_C_i;
Euler_i = dcm2eul(body_C_i) * r2d;

% If input is a row vector, return a row vector:
if(size(Euler_ned, 2) == 3)
    Euler_i = Euler_i';
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100929 JJ:  Generated 2 examples.Added source documentation.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_ned_2_eul_i.m
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
