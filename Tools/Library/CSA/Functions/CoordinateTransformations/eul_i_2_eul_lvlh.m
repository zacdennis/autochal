% EUL_I_2_EUL_LVLH  Converts Orientation w.r.t. Inertial Frame to Orientation w.r.t. Local Vertical Local Horizontal Frame
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eul_i_2_eul_lvlh:
%      Converts Orientation w.r.t. Inertial Frame to Orientation w.r.t. Local
%      Vertical Local Horizontal Frame
% 
% SYNTAX:
%	[euler_lvlh, lvlh_C_i] = eul_i_2_eul_lvlh(P_i, V_i, euler_i)
%
% INPUTS: 
%	Name		Size                Units           Description
%   P_i         [3x1]or[3x1]        [length]        Position in Central Body Inertial
%                                                   Frame
%   V_i         [3x1]or[3x1]        [length/time]   Velocity in Central Body Inertial
%                                                   Frame
%   Euler_i     [3x1]or[3x1]        [rad]           Euler orientation in 
%                                                   Central Body Inertial Frame
%
% OUTPUTS: 
%	Name		Size                Units           Description
%   Euler_lvlh  [3x1]or[3x1]        [rad]           Euler orientation in Local 
%                                                   Vertical Local Horizontal Frame
%   lvlh_C_i    [3x3]               [ND]            Direction Cosine Matrix that
%                                                   converts from the inertial frame
%                                                   into the LVLH frame
% NOTES:
%   Local Vertical - Local Horizontal Coordiante System (LVLH)
%   X Axis -    In Orbital Plane, points through nose of vehicle towards
%               velocity vector (if orbit eccentricity is zero, X is
%               parallel to velocity vector)
%   Y Axis -    Positive out right wing of vehicle; completes coordiante
%               system (Z x X)
%   Z Axis -    Positive through bottom of vehicle; points to center of
%               central body (NADIR)
%   This function uses eul2dcm and dcm2eul.
%
% EXAMPLES:
%	Example 1:A spacecraft's position is P_i=[200 300 400] and velocity is
%	V_i=[100 200 300]. The euler orientation in inertial coordinates is [pi/4
%	pi/6 pi/8]. Find euler orientation angles in LVLH coordinates (Row Input).
%   P_i=[200 300 400]; V_i=[100 200 300]; euler_i=[pi/4 pi/6 pi/8];
% 	[euler_lvlh, lvlh_C_i] = eul_i_2_eul_lvlh(P_i, V_i, euler_i)
%	Returns euler_lvlh =[  -1.9720    0.1106    2.9920 ]
%           lvlh_C_i = [   -0.8339   -0.1516    0.5307
%                          -0.4082    0.8165   -0.4082
%                          -0.3714   -0.5571   -0.7428 ]
%
%	Example 2:A spacecraft's position is P_i=[10; 20; 30] and velocity is
%	V_i=[400; 400; 400]. The euler orientation in LVLH coordinates is
%	[pi/6; pi/10; pi/8]. Find euler orientation angles in inertial frame (Column Input).
%   P_i=[200 300 400]; V_i=[400; 400; 400]; euler_i=[pi/6; pi/10; pi/8];
% 	[euler_lvlh, lvlh_C_i] = eul_i_2_eul_lvlh(P_i, V_i, euler_i)
%	Returns euler_lvlh =[ -2.2168; 0.3042 ; -0.0678 ]
%               lvlh_C_i =[  0.8339    0.1516   -0.5307
%                            0.4082   -0.8165    0.4082
%                           -0.3714   -0.5571   -0.7428 ]   
%
% SOURCE DOCUMENTATION:
%	[1] Vallado, David A.  Fundamentals of Astrodynamics and Applications.  New
%   York: McGraw-Hill Companies, Inc., 1997.  Pages 165,172.  Equation 3-20.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eul_i_2_eul_lvlh.m">eul_i_2_eul_lvlh.m</a>
%	  Driver script: <a href="matlab:edit Driver_eul_i_2_eul_lvlh.m">Driver_eul_i_2_eul_lvlh.m</a>
%	  Documentation: <a href="matlab:pptOpen('eul_i_2_eul_lvlh_Function_Documentation.pptx');">eul_i_2_eul_lvlh_Function_Documentation.pptx</a>
%
% See also eul_lvlh_2_eul_i
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/332
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eul_i_2_eul_lvlh.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [euler_lvlh, lvlh_C_i] = eul_i_2_eul_lvlh(P_i, V_i, euler_i)

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
if ischar(V_i)||ischar(P_i)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(P_i, 1) ~= 3)&&(size(P_i, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
if (size(V_i, 1) ~= 3)&&(size(V_i, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
%% Main Function:
%% Compute Satellite Coordiante System (RSW) Parameters:
Rhat = unitv( P_i );                % [ND]  Normalized Position Vector
Hvec = cross( P_i, V_i );
What = unitv(Hvec);                 % [ND]  Cross-track Position Vector
Shat = cross( What, Rhat );         % [ND]  In Orbit Velocity Vector

%% DCM from Local Vertical/Local Horizontal (lvlh) to Inertial Frame (I):
% converting from RSW to lvlh:
%       x: Rhat -> Shat
%       y: Shat -> -Rhat x Shat
%       z: What -> -Rhat
i_C_lvlh = zeros(3,3);
i_C_lvlh(:,1) = Shat;
i_C_lvlh(:,2) = -What;
i_C_lvlh(:,3) = -Rhat;
lvlh_C_i = i_C_lvlh';

%% DCM from Inertial to Body Frame:
b_C_i = eul2dcm( euler_i );

%% DCM from Local Vertical Local Horizontal to Body Frame:
b_C_lvlh = b_C_i * i_C_lvlh;

%% Compute Local Vertical Local Horizontal Euler Orientation:
euler_lvlh = dcm2eul( b_C_lvlh );

% If input is a row vector, return a row vector:
if(size(euler_i, 2) == 3)
    euler_lvlh = euler_lvlh';
end

end

%% REVISION HISTORY
% YYMMDD INI: note
% 100916 JJ:  Generated 2 examples.Added input checks
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eul_i_2_eul_lvlh.m
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
