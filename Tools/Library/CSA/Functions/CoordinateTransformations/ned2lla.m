% NED2LLA Converts Flat North/East/Down Frame Position to Lat/Lon/Alt
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ned2lla:
%     Converts Flat North/East/Down Frame Position to Lat/Lon/Alt
% 
% SYNTAX:
%	[LLA] = ned2lla(P_ned, CB)
%	[LLA] = ned2lla(P_ned)
%
% INPUTS: 
%	Name		 Size              Units                Description
%	P_ned        [3x1]or [1x3]     [length]             North/East/Down Position
%   CB           {struct}                               Central Body Structure
%     .a         [1x1]             [length]             Semi-major Axis
%     .flatten   [1x1]             [ND]                 Flattening Parameter
%
% OUTPUTS: 
%	Name		Size               Units                Description
%	 LLA        [3x1]or [1x3]      [deg deg length]     Geodetic Latitude, Longitude, Alt
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	Example 1:
%	[LLA] = ned2lla(P_ned, CB)
%	Returns
%
%	Example 2:
%	[LLA] = ned2lla(P_ned, CB)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ned2lla.m">ned2lla.m</a>
%	  Driver script: <a href="matlab:edit Driver_ned2lla.m">Driver_ned2lla.m</a>
%	  Documentation: <a href="matlab:pptOpen('ned2lla_Function_Documentation.pptx');">ned2lla_Function_Documentation.pptx</a>
%
% See also lla2ned, invvincenty 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/351
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/ned2lla.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [LLA] = ned2lla(P_ned, CB)

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
R2D = 180/acos(-1);

Pn = P_ned(1);                  % [dist]
Pe = P_ned(2);                  % [dist]
Pd = P_ned(3);                  % [dist]
dist = sqrt(Pn*Pn + Pe*Pe);     % [dist]
az = atan2(Pe, Pn) * R2D;       % [deg]
    
[Lat, Lon] = invvincenty( 0, 0, az, dist, CB.a, CB.flatten );
Alt = -Pd;

LLA = zeros(1,3);
LLA(1) = Lat;
LLA(2) = Lon;
LLA(3) = Alt;

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/ned2lla.m
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
