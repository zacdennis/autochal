% ORBEL2POSVEL  Converts Classical Orbital Elements to Cartesian Position
% and Velocity
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% OrbEl2PosVel:
%      Converts Classical Orbital Elements to Cartesian Position and
%      Velocity
% 
% SYNTAX:
%	[P_i, V_i, Gamma] = OrbEl2PosVel(a, e, theta, RAAN, i, omega, GM)
%	[P_i, V_i, Gamma] = OrbEl2PosVel(a, e, theta, RAAN, i, omega)
%
% INPUTS: 
%	Name		Size		Units           	Description
%   a           [1x1]       [length]            Semi-major Axis
%   e           [1x1]       [ND]                Eccentricity
%   theta       [1x1]       [deg]               True Anomaly
%   RAAN        [1x1]       [deg]               Right Ascension Logitude of the
%                                               Ascending node
%   i           [1x1]       [deg]               Inclination
%   omega       [1x1]       [deg]               Argument of the Perigee
%   GM          [1x1]       [length^3/time^2]   Central Body Gravitational
%                                               Constant
%                                                       Default= 
%
% OUTPUTS: 
%	Name		Size		Units               Description
%	P_i         [1x3]       [length]            Position in Central Body Inertial
%                                               Frame
%   V_i         [1x3]       [length/time]       Velocity in Central Body Inertial
%                                               Frame
%   Gamma       [1x1]       [deg]               Vertical Flight path angle
%
% NOTES:
%   This function is NOT unit specific.  Unit specific outputs will be
%   based on the units of the inputs (a and GM).  Standard METRIC or 
%   ENGLISH units should be used.
%
%   This function works only on Elliptical Orbits ( 0 <= e < 1 ).
%   Eccentricities that land outside of this range will be reset to zero
%   (circular orbit).
%
% EXAMPLES:
%	Example 1:
%	[P_i, V_i, Gamma] = OrbEl2PosVel(a, e, theta, RAAN, i, omega, GM)
%	Returns
%
%	Example 2:
%	[P_i, V_i, Gamma] = OrbEl2PosVel(a, e, theta, RAAN, i, omega, GM)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit OrbEl2PosVel.m">OrbEl2PosVel.m</a>
%	  Driver script: <a href="matlab:edit Driver_OrbEl2PosVel.m">Driver_OrbEl2PosVel.m</a>
%	  Documentation: <a href="matlab:pptOpen('OrbEl2PosVel_Function_Documentation.pptx');">OrbEl2PosVel_Function_Documentation.pptx</a>
%
% See also PosVel2OrbEl 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/352
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/OrbEl2PosVel.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_i, V_i, Gamma] = OrbEl2PosVel(a, e, theta, RAAN, i, omega, GM)

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
conversions;        % Load Unit Conversions

%% Convert Input Angles:
theta   = theta * C.D2R;
RAAN    = RAAN * C.D2R;
i       = i * C.D2R;
omega   = omega * C.D2R;

%% Compute Semilatus Rectum, [length]:
if(e < 0)
    % Eccentricity out of bounds:
    disp('OrbEl2PosVel Warning: Eccentricity, e, cannot be negative.');
    disp('  Setting e to zero (circular orbit) to avoid errors.');
    e = 0;
elseif(e >= 1)
    % Hyberbolic Orbit:
    disp('OrbEl2PosVel Warning: Orbit is either Parabolic or Hyberbolic.');
    disp('  Function currently does not support Position and Velocity');
    disp('  determination based on Parabolic or Hyberbolic Orbital Elements.');
    disp('  Setting eccentricty to zero to avoid errors.');
    e = 0;
end

%% Error Check Semi-major axis, a:
a = abs(a);

%% Compute Semi-latus rectum, p, [length]:
P = a*(1-e^2);

%% Compute Radial distance, R1, [length]:
R1 = P/(1+e*cos(theta));

%% Compute Position in Perifocal (Orbital) Reference Frame, [length]:
P_p(1) = R1 * cos(theta);
P_p(2) = R1 * sin(theta);
P_p(3) = 0.0;

%% Compute Velocity in Perifocal (Orbital) Reference Frame, [length/sec]:
V_p(1) = -sqrt(GM/P) * sin(theta);
V_p(2) = sqrt(GM/P) * (e + cos(theta));
V_p(3) = 0.0;

%% Compute the Diretion Cosine Matrix from the Geocentric-equatorial
%  reference frame (inertial, i) to the perifocal reference frame
%   (orbital, p)
p_C_i(1,1) = cos(RAAN)*cos(omega) - sin(RAAN)*sin(omega)*cos(i);
p_C_i(1,2) = sin(RAAN)*cos(omega) + cos(RAAN)*sin(omega)*cos(i);
p_C_i(1,3) = sin(omega)*sin(i);
p_C_i(2,1) = -cos(RAAN)*sin(omega) - sin(RAAN)*cos(omega)*cos(i);
p_C_i(2,2) = -sin(RAAN)*sin(omega) + cos(RAAN)*cos(omega)*cos(i);
p_C_i(2,3) = cos(omega)*sin(i);
p_C_i(3,1) = sin(RAAN)*sin(i);
p_C_i(3,2) = -cos(RAAN)*sin(i);
p_C_i(3,3) = cos(i);

% Compute DCM from perifocal to inertial frame:
i_C_p = p_C_i';

%% Compute Position / Velocity in Inertial Reference Frame:
P_i = (i_C_p * P_p')';  % [length]
V_i = (i_C_p * V_p')';  % [length / sec]

%% Compute Gamma, [deg]:
H_i = cross( P_i, V_i );
Gamma = -acos( norm(H_i) / (norm(P_i)*norm(V_i)) )*C.R2D;

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/OrbEl2PosVel.m
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
