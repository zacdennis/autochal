% NED2ECEF Converts Central Body North / East / Down Coordinates to Central Body
%   Fixed Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ned2ecef:
%    Converts Central Body North / East / Down Coordinates to Central Body
%    Fixed Coordinates
% 
% SYNTAX:
%	[P_f, f_C_ned] = ned2ecef(P_ned, lat, lon)
%	[P_f, f_C_ned] = ned2ecef(P_ned)
%
% INPUTS: 
%	Name		Size            Units		Description
%   Pned        [3x1] or [1x3]  [length]    Vector in North East Down Frame
%   lat         [1x1]           [deg]       Geodetic Latitude
%   lon         [1x1]           [deg]       Longitude
%                                               
% OUTPUTS: 
%	Name		Size            Units		Description
%   P_f         [3x1] or [1x3]  [length]    Vector in Central Body Fixed Frame
%   f_C_ned     [3x3]           [ND]        DCM from North East Down Frame 
%                                           to Central Body Fixed Frame
%
% NOTES:
%   This function works on positions, velocity, and accelerations.  It does
%   NOT work for Euler angles.  Direction cosine matrices must be 
%   multiplied together for such orientations to be computed.
% 
% EXAMPLES:
%	Example 1: A spacecraft position in ned coordinates is [5*10^6 8*10^6
%	9*10^6]. The spacercaft latitude is 55.5 degrees and longitude is -90.8 degrees.
%   Find position in ecef (Row Vector).
%   P_ned=[200 300 500]; lat=55.5; lon=-90.8;
% 	[P_f, f_C_ned] = ned2ecef(P_ned, lat, lon)
%	Returns P_f = [ -448.0284  300.0000 -298.7818 ]
%           f_C_ned =[  -9.2183    8.0000   -4.5851
%                        0              1         0
%                        0.5664         0   -0.8241 ]
%
%	Example 2: A spacecraft position in ned coordinates is [7*10^6 8*10^6
%	8*10^6]. The spacecraft is right above where the equator and the prime 
%   meridian intersect (default). Find position in ecef (Column Vector).
%   P_ned=[7*10^6; 8*10^6; 8*10^6]; 
% 	[P_f, f_C_ned] = ned2ecef(P_ned)
%	Returns P_f = [-8000000 8000000 7000000 ]
%           f_C_ned =[  0     0    -1
%                       0     1     0
%                       1     0     0  ]
%
% SOURCE DOCUMENTATION:
%	[1]    Yechout, Thomas R. Introduction to Aircraft Flight Mechanics.
%          AIAA Educational Series, Reston, VA, Copyright 2003 P.40
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ned2ecef.m">ned2ecef.m</a>
%	  Driver script: <a href="matlab:edit Driver_ned2ecef.m">Driver_ned2ecef.m</a>
%	  Documentation: <a href="matlab:pptOpen('ned2ecef_Function_Documentation.pptx');">ned2ecef_Function_Documentation.pptx</a>
%
% See also ecef2ned 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/349
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/ned2ecef.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [P_f, f_C_ned] = ned2ecef(P_ned, lat, lon)
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
if ischar(lat)||ischar(P_ned)
    error([mfnam ':InputArgCheck'], ['Inputs must be numeric!  See ' mlink ' documentation for help.']);
end

if (size(P_ned, 1) ~= 3)&&(size(P_ned, 2) ~= 3)
    error([mfnam ':InputArgCheck'], ['Inputs must be of right size! See ' mlink ' documentation for help.']);
end
%% Main Function:
%% DCM from Fixed Frame to North / East / Down Frame:
ned_C_f = [ -sind(lat)*cosd(lon)    -sind(lat)*sind(lon)    cosd(lat);
            -sind(lon)              cosd(lon)                0;
            -cosd(lat)*cosd(lon)    -cosd(lat)*sind(lon)    -sind(lat)];
f_C_ned = ned_C_f';
        
%% Compute Component in North / East / Down Frame:        
if size(P_ned, 1) == 3
    P_f = f_C_ned * P_ned;
else
    P_f = (f_C_ned * P_ned')';
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100920 JJ:  Generated 2 examples added documentation.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/ned2ecef.m
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
