% BACKOUTTARGET find target and origin coord given downrng and crossrng err  
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BackOutTarget:
%   Compute Target Coordinates and Backout True Origin Coordinates given
%   Downrange and Crossrange Errors.
%   Assumes WGS-84 Oblate Ellipsoid (Vincenty and Inverse Vincenty
%   functions utilized).
% 
% SYNTAX:
%	[lat0, lon0, bearing0, latD, lonD] 
%       = BackOutTarget(originLat, originLon, originBearing, ...
%       targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)
% *************************************************************************
% * #NOTE: original function syntax listed as:
% *	[lat0, lon0, bearing0, latD, lonD] 
% *     = BackOutTarget(targetLat, targetLon, targetBearing, 
% *         targetDownrange, offsetCrossrange, offsetDownrange)
% * -JPG
% *************************************************************************
%
% INPUTS: 
%	Name            Size	Units       Description
%   originLat       [1x1]   [deg]       Geodetic Latitude of Origin
%   originLon       [1x1]   [deg]       Longitude of Origin
%   originBearing   [1x1]   [deg]       Initial Bearing (Azimuth) of 
%                                       Desired Target from Origin 
%                                       (0 deg is due North; Positive 
%                                       Rotation towards 90 deg East)
%   targetDownrange [1x1]   [length]    Downrange Distance from Target to
%                                       Starting Point
%   offsetCrossrange [1x1]  [length]    Crossrange Error.  Additional 
%                                       distance applied to the starting 
%                                       location. This distance is 
%                                       perpendicular to the range vector 
%                                       from the starting point to the
%                                       target.
%   offsetDownrange [1x1]   [length]    Downrange Error. Additional 
%                                       distance applied to the Desired 
%                                       Downrange.
%   CentralBody     [struct]            Central Body Parameter Structure
%       .a          [1x1]   [length]    Central Body Semi-major Axis
%       .f          [1x1]   [ND]        Central Body Flattening Parameter
%
% OUTPUTS: 
%	Name            Size	Units		Description
%   lat0            [1x1]   [deg]       Geodetic Latitude of Start Point
%   lon0            [1x1]   [deg]       Longitude of Start Point
%   bearing0        [1x1]   [deg]       "Assumed" Initial Bearing (Azimuth) 
%                                       of Target from Starting Point 
%                                       (0 deg is due North)  This angle  
%                                       does notaccount for affects due to 
%                                       Downrange and Crossrange offsets.
%   trueRange       [1x1]   [length]    True Range from Start Point to the
%                                       Target Given Downrange and 
%                                       Crossrange Errors
%   trueBearing     [1x1]   [deg]       True Initial Bearing from Start 
%                                       Point to the Target Given Downrange 
%                                       and Crossrange Errors 
%                                       (0 deg is due North)
%   latD            [1x1]   [deg]       Latitude of Target
%   lonD            [1x1]   [deg]       Longitude of Target
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lat0, lon0, bearing0, latD, lonD] = BackOutTarget(originLat, originLon, originBearing, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lat0, lon0, bearing0, latD, lonD] = BackOutTarget(originLat, originLon, originBearing, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BackOutTarget.m">BackOutTarget.m</a>
%	  Driver script: <a href="matlab:edit Driver_BackOutTarget.m">Driver_BackOutTarget.m</a>
%	  Documentation: <a href="matlab:pptOpen('BackOutTarget_Function_Documentation.pptx');">BackOutTarget_Function_Documentation.pptx</a>
%
% See also vincenty, invvincenty
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/380
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/BackOutTarget.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lat0, lon0, bearing0, latD, lonD] = BackOutTarget(originLat, originLon, originBearing, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)

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

%% Initialize Outputs:
lat0= -1;
lon0= -1;
bearing0= -1;
latD= -1;
lonD= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; originBearing= ''; originLon= ''; originLat= ''; 
%       case 1
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; originBearing= ''; originLon= ''; 
%       case 2
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; originBearing= ''; 
%       case 3
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; 
%       case 4
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; 
%       case 5
%        CentralBody= ''; offsetDownrange= ''; 
%       case 6
%        CentralBody= ''; 
%       case 7
%        
%       case 8
%        
%  end
%
%  if(isempty(CentralBody))
%		CentralBody = -1;
%  end
%% Main Function:
bearing0 = originBearing;

%% Compute the Latitude/Longitude Location of an Intermediate Point (Pt. B)
%  given the origin coordinates, initial bearing, and downrange
%  offset.  Note that OB is the final bearing from the Origin to Pt B.
[latB, lonB, bearing1_OB] = invvincenty( originLat, originLon, ...
    originBearing, (-offsetDownrange), CentralBody.a, CentralBody.flatten );

%% Compute the Latitude/Longitude Location of the Final (D)estination Point
[latD, lonD, bearing1_OD] = invvincenty( originLat, originLon, ...
    originBearing, targetDownrange, CentralBody.a, CentralBody.flatten );

% Compute Initial Bearing from Intermediate Pt. B to Destination
[rangeBD, bearing0_BD] = vincenty( latB, lonB, latD, lonD, ...
    CentralBody.a, CentralBody.flatten);

%% Rotate Initial Bearing from Pt. B to Target by 90 Degrees and Recompute
%  Position based on Crossrange Error
[lat0, lon0, bearing_B0] = invvincenty( latB, lonB, (bearing0_BD+90), ...
    offsetCrossrange, CentralBody.a, CentralBody.flatten );

%% Compute Initial Bearing and True Distance from Initial Location to
%  Target Point
[trueRange, trueBearing] = vincenty( lat0, lon0, latD, lonD, ...
    CentralBody.a, CentralBody.flatten );

%% Compile Outputs:
%	lat0= -1;
%	lon0= -1;
%	bearing0= -1;
%	latD= -1;
%	lonD= -1;

end % << End of function BackOutTarget >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
% 060405 MWS: Updated for METRIC & ENGLISH compatibility
% 051108 MWS: Converted from Haversine to Vincenty
% 051107 MWS: Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username
% MWS: Mike Sufana          :  mike.sufana@ngc.com  :  sufanmi 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
