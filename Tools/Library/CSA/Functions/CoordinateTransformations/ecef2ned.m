% ECEF2NED Converts Central Body Fixed Coordinates to Central Body North/East/Down Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ecef2ned:
%     Converts Central Body Fixed Coordinates to Central Body North / East /
%     Down Coordinates
% 
% SYNTAX:
%	[Pned, ned_C_f] = ecef2ned(P_f, lat, lon)
%
% INPUTS: 
%	Name            Size            Units		Description
%	P_f             [3x1] or [1x3]  [Varies]    Vector in Central Body Fixed Frame
%   lat             [1x1]           [deg]       Geodetic Latitude
%   lon             [1x1]           [deg]       Longitude
%
% OUTPUTS: 
%	Name            Size            Units		Description
%	Pned            [3x1] or [1x3]  [Varies]    Vector in North East Down Frame
%   ned_C_f         [3x3]           [ND]        DCM from Central Body Inertial Frame
%                                               to North East Down Frame
% NOTES:
%	This function works on positions, velocity, and accelerations.  It does
%   NOT work for Euler angles.  Direction cosine matrices must be 
%   multiplied together for such orientations to be computed.
%
% EXAMPLES:
%	Example 1: Find the vector in NED coordinates given the following
%	postions in body fixed frame. 
%   P_f=[100 200 500];lat=43.65; lon=-75.65;
% 	[P_ned, ned_C_f] = ecef2ned(P_f, lat, lon)
%	Returns Pned =[ 478.4204  146.4489 -222.86 ]
%           ned_C_f =[ -0.1711    0.6687    0.7236
%                       0.9688    0.2478         0
%                      -0.1793    0.7010   -0.6903 ]
%	
%   Example 2: Find the vector in NED coordinates given the following
%	postions in body fixed frame. 
%   P_f=[50; 150; 200];lat=0; lon=-90.55;
% 	[P_ned, ned_C_f] = ecef2ned(P_f, lat, lon)
%	Returns Pned =[ 200  48.5578 150.4730 ]
%           ned_C_f =[  0     0      1
%                       1  -0.0096   0
%                     0.0096  1      0 ]
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ecef2ned.m">ecef2ned.m</a>
%	  Driver script: <a href="matlab:edit Driver_ecef2ned.m">Driver_ecef2ned.m</a>
%	  Documentation: <a href="matlab:pptOpen('ecef2ned_Function_Documentation.pptx');">ecef2ned_Function_Documentation.pptx</a>
%
% See also ned2ecef 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/324
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/ecef2ned.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [P_ned, ned_C_f] = ecef2ned(P_f, lat, lon)

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
if ischar(P_f)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
if (length(lat) ~= length(lon)) && (size(P_f, 1) ~= 3)
    error([mfnam ':InputArgCheck'], ['Incorrect Input size! See ' mlink ' documentation for help.']);
end
%% Main Function:
%% DCM from Fixed Frame to North / East / Down Frame:
ned_C_f = [ -sind(lat)*cosd(lon)    -sind(lat)*sind(lon)    cosd(lat);
            -sind(lon)               cosd(lon)                0;
            -cosd(lat)*cosd(lon)    -cosd(lat)*sind(lon)    -sind(lat)];

%% Compute Component in North / East / Down Frame:        
if size(P_f, 1) == 3
    P_ned = ned_C_f * P_f;
else
    P_ned = (ned_C_f * P_f')';
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100920 JJ:  Added documentation and examples
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/ecef2ned.m
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
