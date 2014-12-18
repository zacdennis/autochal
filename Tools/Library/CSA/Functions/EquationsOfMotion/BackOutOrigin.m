% BACKOUTORIGIN computes initial position with a target point, desired downrange, and azimuth from the origin to target
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BackOutOrigin:
%   Back Out Origin / Starting Point
%   Compute Initial Position Given a Target Point, Desired Downrange, and
%   Azimuth from the Origin to the Target.  Position is also adjusted for
%   user defined Crossrange and Downrange Errors. 
%   Assumes WGS-84 Oblate Ellipsoid (Vincenty and Inverse Vincenty SP
%   functions utilized).
% 
% SYNTAX:
%	[lat0, lon0] = BackOutOrigin(targetLat, targetLon, targetAzimuth, ...
%          targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)
%	[lat0, lon0] = BackOutOrigin(targetLat, targetLon, targetAzimuth, ...
%          targetDownrange, offsetCrossrange, offsetDownrange)
%
% INPUTS: 
%	Name            	Size	Units       Description
%   targetLat           [1x1]   [deg]       Geodetic Latitude of Target
%   targetLon           [1x1]   [deg]       Longitude of Target
%   targetAzimuth       [1x1]   [deg]       Initial Bearing (Azimuth) of 
%                                           Desired Target from Start Point
%                                           (0 deg isdue North; Positive
%                                           Rotation towards 90 deg East)
%   targetDownrange     [1x1]   [length]    Downrange Distance from Target 
%                                           to Starting Point
%   offsetCrossrange    [1x1]   [length]    Crossrange Error.  Additional 
%                                           distance applied to the 
%                                           starting location.  This 
%                                           distance is perpendicular to 
%                                           the range vector from the
%                                           starting point to the target.
%   offsetDownrange     [1x1]   [length]    Downrange Error. Additional 
%                                           distance applied to the Desired
%                                           Downrange.
%   CentralBody         [struct]            Central Body Parameter
%                                           Structure
%       .a              [1x1]   [length]    Central Body Semi-major Axis
%       .f              [1x1]   [ND]        Central Body Flattening 
%                                           Parameter
%
% OUTPUTS: 
%	Name            	Size	Units		Description
%   lat0                [1x1]   [deg]       Geodetic Latitude of Start 
%                                           Point
%   lon0                [1x1]   [deg]       Longitude of Start Point
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
%	[lat0, lon0] = BackOutOrigin(targetLat, targetLon, targetAzimuth, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lat0, lon0] = BackOutOrigin(targetLat, targetLon, targetAzimuth, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)
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
%	Source function: <a href="matlab:edit BackOutOrigin.m">BackOutOrigin.m</a>
%	  Driver script: <a href="matlab:edit Driver_BackOutOrigin.m">Driver_BackOutOrigin.m</a>
%	  Documentation: <a href="matlab:pptOpen('BackOutOrigin_Function_Documentation.pptx');">BackOutOrigin_Function_Documentation.pptx</a>
%
% See also vincenty, invvincentySP
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/379
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/BackOutOrigin.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lat0, lon0] = BackOutOrigin(targetLat, targetLon, targetAzimuth, targetDownrange, offsetCrossrange, offsetDownrange, CentralBody)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; targetAzimuth= ''; targetLon= ''; targetLat= ''; 
%       case 1
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; targetAzimuth= ''; targetLon= ''; 
%       case 2
%        CentralBody= ''; offsetDownrange= ''; offsetCrossrange= ''; targetDownrange= ''; targetAzimuth= ''; 
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
%% Compute the Origin Assuming Zero Crosstrack Error
%   Latitude/Longitude Location of an Intermediate Point (Pt. B)
%   Note: bearingTB is bearing from Target to Pt B.
[latB, lonB, bearingTB] = invvincentySP( targetLat, targetLon, ...
    targetAzimuth, (targetDownrange + offsetDownrange), ...
    CentralBody.a, CentralBody.flatten );

%   Rotate Initial Azimuth 90 and recompute position to account for
%   Cross-track Error

%% Rotate Initial Bearing from Pt. B to Target by 90 Degrees and Recompute
%  Position based on Crossrange Error
[lat0, lon0, bearingB0] = invvincentySP( latB, lonB, (targetAzimuth+90), ...
    offsetCrossrange, CentralBody.a, CentralBody.flatten );

%% Compute Initial Bearing and True Distance from Initial Location to
%  Target Point
[trueRange, bearing0] = vincenty( lat0, lon0, targetLat, targetLon, ...
    CentralBody.a, CentralBody.flatten );

%% Compile Outputs:
%	lat0= -1;
%	lon0= -1;

end % << End of function BackOutOrigin >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
% 060405 MWS: Updating for both METRIC & ENGLISH compatible
% 051116 MWS: Updating to VincentySP
% 051108 MWS: Converted from Haversine to Vincenty
% 051107 MWS: Created.
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
