% ECI2NED Converts Central Body Inertial Coordinates to Central Body North/East/Down Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eci2ned:
%     Converts Central Body Inertial Coordinates to Central Body North / East /
%     Down Coordinates
% 
% SYNTAX:
%	[P_ned, ned_C_i] = eci2ned(P_i, mst, lat, lon)
%	[P_ned, ned_C_i] = eci2ned(P_i, mst)
%
% INPUTS: 
%	Name		Size            Units		Description
%	P_i         [3x1] or [1x3]  [length]    Vector in Central Body Inertial Frame
%   mst         [1x1]           [deg]       Mean Sidereal Time
%   lat         [1x1]           [deg]       Geodetic Latitude
%   lon         [1x1]           [deg]       Longitude
%                                                Default: lon = 0 (prime meridian)
%                                                         lat = 0 (equator)   
% OUTPUTS: 
%	Name		Size            Units		Description
%	Pned        [3x1] or [1x3]  [length]    Vector in North East Down Frame
%   ned_C_i     [3x3]           [ND]        DCM from Central Body Inertial Frame
%                                           to North East Down Frame
%
% NOTES:
%	Function calls eci2ecef and ecef2ned
%   This function works on positions, velocity, and accelerations.  It does
%   NOT work for Euler angles.  Direction cosine matrices must be 
%   multiplied together for such orientations to be computed.
%   
% EXAMPLES:
%	Example 1: A spacecraft position in eci coordintaes are [7*10^6 8*10^6
%	6*10^6]. Cosidering the mean sidereal time is 60 and the latitude and
%	lon are 35.5 and -80.65 respectively.  Find position in NED
%	coordinates (Row vector).
%   P_i=[7*10^6 8*10^6 6*10^6];mst=60; lat=35.5; lon=-80.65;
% 	[P_ned, ned_C_i] = eci2ned(P_i, mst, lat, lon)
%	Returns P_ned =  1.0e+007 * [1.0974 -0.1748 0.5052]
%           ned_C_i= [  0.4491    0.3682    0.8141
%                       0.6341   -0.7733         0
%                       0.6295    0.5162   -0.5807 ] 
%
%	Example 2: A spacecraft position in eci coordintaes are [9*10^6 9*10^6
%	9*10^6]. Cosidering the mean sidereal time is 45 and the spacecraft is right
%   above where the equator and the prime meridian intersect (default). Find 
%   position in NED coordinates (Column vector).
%   P_i=[9*10^6; 9*10^6; 9*10^6];mst=45;
% 	[P_ned, ned_C_i] = eci2ned(P_i, mst)
%	Returns P_ned =  1.0e+007 * [0.9; 1.2728; 0]
%           ned_C_i= [  0         0         1
%                       0.7071    0.7071    0
%                      -0.7071    0.7071    0  ] 
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.39-40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eci2ned.m">eci2ned.m</a>
%	  Driver script: <a href="matlab:edit Driver_eci2ned.m">Driver_eci2ned.m</a>
%	  Documentation: <a href="matlab:pptOpen('eci2ned_Function_Documentation.pptx');">eci2ned_Function_Documentation.pptx</a>
%
% See also eci2ecef, ecef2ned, ned2eci
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/327
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eci2ned.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [P_ned, ned_C_i] = eci2ned(P_i, mst, lat, lon)

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

%% Input check
if nargin<4
    lon=0;
end
if nargin <3
    lat=0;
end
   
if ischar(P_i)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
[P_f, f_C_i] = eci2ecef( P_i, mst);
[P_ned, ned_C_f] = ecef2ned( P_f, lat, lon );
ned_C_i = ned_C_f * f_C_i;

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100920 JJ:  Generated 2 examples added documentation.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eci2ned.m
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
