% EUL_I_2_EUL_NED Converts Euler Angles w.r.t. the Oblate Central Body Inertial Frame into the North/East/Down Coordinate Frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_i_2_eul_ned:
%   Converts Euler Angles w.r.t. the Oblate Central Body Inertial Frame into
%   the North/East/Down Coordinate Frame
% 
% SYNTAX:
%   [Euler_ned, body_C_ned] = eul_i_2_eul_ned(lat, lon, mst, Euler_i)
%
% INPUTS: 
%	Name		Size             Units          Description
%   lat         [1x1]            [deg]          Geodetic Latitude
%   lon         [1x1]            [deg]          Longitude
%   mst         [1x1]            [deg]          Mean Sidereal Time (celestial longitude)
%   Euler_i     [3x1]or[1x3]     [deg]          Euler orientation in Central Body Inertial 
%                                               Frame
%                                                   
% OUTPUTS: 
%	Name		Size             Units       	Description
%	Euler_ned   [3x1]or[1x3]     [deg]          Euler orientation in North East Down Frame
%   body_C_ned  [3x3]            [ND]           DCM from North East Down Frame to Aircraft
%                                               Body Frame
% NOTES:
%	This function first transforms the euler angles into a direction cosine
%	matrix rotation. This rotation is then propagated to the inertial frame
%	using eul2dcm and later to the LLA. The function then reverts the process using dcm2eul to
%	recover the euler angles in the NED coordinate frame.
%
% EXAMPLES:
%	Example 1: The coordinates of an aircraft flying over Paris are
%	latitude = 48.5 and longitude = 2.2 degress. If the orientation of the
%	aircraft is [30 45 60] degrees w.r.t to inertial frame. Find the orientation 
%   of the aircraft in NED coordinates. mst=30. (row vector)
%   lat=48.5; lon=2.2; mst=30; Euler_i=[30 45 60];
% 	[Euler_ned, body_C_ned] = eul_i_2_eul_ned(lat, lon, mst, Euler_i)
%	Returns Euler_ned = [ -168.1259   -6.6110  160.6102 ]
%          body_C_ned = [  -0.9370    0.3298    0.1151
%                           0.3025    0.9310   -0.2044
%                          -0.1746   -0.1567   -0.9721 ]
%
%	Example 2: The coordinates of a spacecraft flying over New York are
%	latitude = 40.4 and longitude = -74.0 (west) degress. If the orientation of the
%	aircraft is [20 40 90] degrees w.r.t to inertial frame. Find the orientation 
%   of the aircraft in NED coordinates. mst=45. (Column vector)
%   lat=40.4; lon=-74.0; mst=45; Euler_i=[20; 40; 90];
% 	[Euler_ned, body_C_ned] = eul_i_2_eul_ned(lat, lon, mst, Euler_i)
%	Returns Euler_ned = [ 131.2616;  -44.3811;  110.3726 ]
%          body_C_ned = [  -0.2488    0.6700    0.6994
%                           0.8013   -0.2633    0.5372
%                           0.5441    0.6941   -0.4713 ]
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_i_2_eul_ned.m">eul_i_2_eul_ned.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_i_2_eul_ned.m">Driver_eul_i_2_eul_ned.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_i_2_eul_ned_Function_Documentation.pptx');">eul_i_2_eul_ned_Function_Documentation.pptx</a>
%
% See also eul_ned_2_eul_i
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/333
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_i_2_eul_ned.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [Euler_ned, body_C_ned] = eul_i_2_eul_ned(lat, lon, mst, Euler_i)

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
if ischar(lat)||ischar(lon)||ischar(Euler_i)|| ischar(mst)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(Euler_i, 1) ~= 3)&&(size(Euler_i, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Size of Euler angles must be [1x3] or [3x1]! See ' mlink ' documentation for help.']);
end

%% Main Function:
%% Conversions
d2r = pi/180;
r2d = 180/pi;

%% Compute Direction Cosine Matrices:
% Inertial to Fixed:
rotI_F = [0; 0; mst] * d2r;         % [rad]
f_C_i = eul2dcm(rotI_F);

% Fixed to LLA:
rotF_LLA = [0; -lat; lon] * d2r;    % [rad]
lla_C_f = eul2dcm(rotF_LLA);

% LLA to North East Down:
rotLLA_NED = [0; -90; 0] * d2r;     % [rad]
ned_C_lla = eul2dcm(rotLLA_NED);

% Inertial to Body:
body_C_i = eul2dcm(Euler_i * d2r);

% North East Down to Body:
body_C_ned = body_C_i * (ned_C_lla * lla_C_f * f_C_i)';
Euler_ned = dcm2eul(body_C_ned) * r2d;

% If input is a row vector, return a row vector:
if(size(Euler_i, 2) == 3)
    Euler_ned = Euler_ned';
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100929 JJ:  Generated 2 examples.Added source documentation.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_i_2_eul_ned.m
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
