% INVHAVERSINE computes a destination given a point, bearing and distance (spherical)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% invhaversine:
%   Computes the destination point given a distance and bearing from 
%   the start point.  This function assumes a spherical central
%   body.
% SYNTAX:
%	[lat2, lon2, bearing2] = invhaversine(lat1, lon1, bearing1, dist, R)
%	[lat2, lon2, bearing2] = invhaversine(lat1, lon1, bearing1, dist)
%
% INPUTS: 
%	Name		Size		Units		Description
%	lat1 		[Variable]	[deg]		Geocentric Latitude of Point #1
%	lon1 		[Variable] 	[deg] 		Longitude of Point #1
%   bearing		[Variable]  [deg]  		Initial bearing from point #1
%                                       towards point #2
%	dist		[Variable]  [length]    Distance between Point #1 and Point
%                                       #2
%	R           [Variable]  [length]    Radius of Central Body
%                                       
%                                       Default Values:
%                                       'R' is assumed to be the WGS-84
%                                       Earth Radius.
%                                       R = 6378.137 km
% OUTPUTS: 
%	Name		Size		Units		Description
%	lat2 		[Variable] 	[deg]  		Geocentric Latitude of Point #2
%	lon2 		[Variable]	[deg]  		Longitude of Point #2
%   bearing2    [Variable]  [deg]       Final Bearing from Point # 1 
%                                       towards Point # 2, {0 degrees is 
%                                       due North, positive rotation 
%                                       towards East)
% NOTES:
%   This calculation is not unit specific.  Standard METRIC [m] or ENGLISH 
%   [ft] distance should be used.
%	Inputs should have the same dimensions, which can be scalar
%	([1]), a vector ([1xN] or [Nx1]), or a multi-dimensional matrix 
%   (M x N x P x ...]).  The outputs Lat and Lon will carry the same
%   dimensions as the inputs.
%   To calculate initial bearing from point #2 to point #1, add 180 degrees
%   to bearing2 and mod(bearing2, 360).
%   invhaversine is ill-defined at pole points (+/- 90 Latitude).  At these
%   points, the path will travel along the lon1 given since bearing
%   is always 0 or 180 depending on the pole.
%
% EXAMPLES:	
%   Example 1: Singular Inputs
%   A simple case, running invhaversine with all scalar arguments heading
%   due north.
%
%   lat1 = 10;              %[deg]
%   lon1 = 20;              %[deg]
%   bearing1 = 0;           %[deg]
%   dist = 2000;            %[km]
%   R = 6371;               %[km]
%   [lat2, lon2, bearing2] = invhaversine(lat1, lon1, bearing1, dist, R);
%	
%   Expected Outputs:
%   lat2:    27.986  [deg]
%   lon2:    20.000  [deg]
%   bearing2: 0.000  [deg]
%
%   Example 2: Vector Case
%   Running invhaversine with multiple bearings.  The origin is Sydney,
%   Australia, and this shows various endpoints when traveling the same
%   distance, but with different initial bearings.
%
%   lat1 = -34;                          %[deg]
%   lon1 = 151;                          %[deg]
%   bearing1 = [0 45 90 180 270];        %[deg]
%   dist = 12500;                        %[km]
%   R = 6371;                            %[km]
%   [lat2, lon2, bearing2] = invhaversine(lat1, lon1, bearing1, dist, R);
%
%   Expected Outputs:
%   lat2:        78.415     49.039     12.312    -33.585     12.312 [deg]
%   lon2:       151.000   -123.323   -100.121    -29.000     42.121 [deg]
%   bearing2:     0.000     63.412     58.055      0.000    301.945 [deg]
%
% SOURCE DOCUMENTATION:
%	[1]    http://www.movable-type.co.uk/scripts/LatLong.html
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit invhaversine.m">invhaversine.m</a>
%	  Driver script: <a href="matlab:edit Driver_invhaversine.m">Driver_invhaversine.m</a>
%	  Documentation: <a href="matlab:pptOpen('invhaversine_Function_Documentation.pptx');">invhaversine_Function_Documentation.pptx</a>
%
% See also HAVERSINE, VINCENTY, INVVINCENTY
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/370
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/invhaversine.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lat2, lon2, bearing2] = invhaversine(lat1, lon1, bearing1, dist, R)

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
lat2= -1;
lon2= -1;
bearing2= -1;

%% Input Argument Conditioning:
if nargin < 4
   disp([mfnam ' :: Please refer to useage of invhaversine' endl ...
       'Syntax: [lat2, lon2, bearing2] = invhaversine(lat1, lon1, '...
       'bearing1, dist, R)']);
   return;
end;

if nargin == 4
    R = 6378.1370;      % [km]   WGS-84 Earth Radius
end

if (isempty(lat1) || isempty(lon1) || isempty(bearing1) || isempty(dist)...
        || isempty(R))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(lat1) || ischar(lon1) || ischar(bearing1) || ischar(dist) || ...
        ischar(R))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
R2D = 180.0/acos(-1);   % Radians to Degrees
bearing1 = mod(bearing1+360.0, 360.0); %Shifting bearing to 0-360. 
[lat1 lon1] = CheckLatLon(lat1, lon1);

%% Compute Destination Latitude/Longitude [deg]
lat2 = asin( sind(lat1).*cosd(dist./R.*R2D) ...
    + cosd(lat1).*sind(dist./R.*R2D).*cosd(bearing1) ) .* R2D;
lon2 = lon1 + atan2( sind(bearing1).*sind(dist./R*R2D).*cosd(lat1), ...
    cosd(dist./R.*R2D)-sind(lat1).*sind(lat2) ) .* R2D;

%% Wrap Longitude to be within +/- 180
[lat2 lon2] = CheckLatLon(lat2, lon2);

%% Compute Final Bearing [deg]
dlon = lon1 - lon2;     % [deg]
bearing2 = atan2( sind(dlon).*cosd(lat1), ...
   cosd(lat2).*sind(lat1) - sind(lat2).*cosd(lat1).*cosd(dlon) ).*R2D +180;
bearing2 = mod(bearing2, 360);    % [deg]

end % << End of function invhaversine >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101006 JPG: Simplified the example cases and formatted a bit.
% 101004 JPG: Fixed the help function information.
% 100929 JPG: Added CheckLatLon to ensure inputs are correct.
% 100923 JPG: Modified the code to be able to take in vector and matrix
%             inputs.  Also added some error checking.
% 100922 JPG: Filled in the function according to CoSMO standard.
% 100922 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  James.Gray2@ngc.com  :  g61720 

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
