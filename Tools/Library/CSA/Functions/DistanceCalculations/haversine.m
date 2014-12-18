% HAVERSINE finds Great-Circle distance and relative bearing between points (spherical) 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% haversine:
%    Computes Great-Circle Distance and Initial Relative Bearing between
%    Two Latitude/Longitude Points.  The Distance is commonly referred to
%    as the "as-the-crow-flies" distance.  Assumes Spherical Central Body. 
% SYNTAX:
%	[dist, bearing, bearing2] = haversine(lat1, lon1, lat2, lon2, R)
%	[dist, bearing, bearing2] = haversine(lat1, lon1, lat2, lon2)
%
% INPUTS: 
%	Name		Size		Units		Description
%	lat1 		[Variable]	[deg]		Geocentric Latitude of Point #1
%	lon1 		[Variable] 	[deg] 		Longitude of Point #1
%	lat2 		[Variable] 	[deg]  		Geocentric Latitude of Point #2
%	lon2 		[Variable]	[deg]  		Longitude of Point #2
%	R           [Variable] 	[length]    Radius of Central Body
%
%                                       Default Values:
%                                       'R' is assumed to be the WGS-84
%                                       Earth Radius.
%                                       R = 6378.137 km
% OUTPUTS: 
%	Name		Size		Units		Description
%	dist		[Variable]  [length]    Distance between Point #1 and Point
%                                       #2
%	bearing1	[Variable]  [deg]  		Initial bearing from point #1
%                                       towards point #2, (0 degrees is due
%                                       North, positive rotation towards
%                                       East)
%	bearing2	[Variable]  [deg]  		Final bearing from point #1
%                                       towards point #2, (0 degrees is due
%                                       North, positive rotation towards
%                                       East)
% NOTES:   
%	This calculation is not unit specific.  Output distance will be of same
%	units as input distance.  Standard METRIC [m] or ENGLISH [ft] distance
%	should be used.
%	Inputs should have the same dimensions, which can be scalar
%	([1]), a vector ([1xN] or [Nx1]), or a multi-dimensional matrix 
%   (M x N x P x ...]).  The outputs Lat and Lon will carry the same
%   dimensions as the inputs.
%   To calculate initial bearing from point #2 to point #1, add 180 degrees
%   to bearing2 and mod(bearing2, 360).
%
% EXAMPLES:
%   Example 1: Singular Inputs
%   A simple case, running haversine with all scalar arguments.  The origin
%   is Manila, Philippines and the destination is San Fransisco, USA.
%
%   lat1 = 14.5833;         %[deg]
%   lon1 = 120.9833;        %[deg]
%   lat2 = 37.75;           %[deg]
%   lon2 = -122.68;          %[deg]
%   R = 6371;               %[km]
%   [dist, bearing, bearing2] = haversine(lat1, lon1, lat2, lon2, R);
%   Returns     dist:   11195.1843 [km]
%               bearing:   46.1463 [deg]
%               bearing2: 118.0399 [deg]
%
%   Example 2: Vector Case
%   Running a mixed case, with a single origin and multiple destinations.
%   The origin is approximately Washington DC, USA.  The three destinations
%   are Baghdad, Iraq, Moscow, Russia, and Beijing, China respectively.
%
%   lat1 = 38.95;                               %[deg]
%   lon1 = -77.46;                              %[deg]
%   lat2 = [33.3333 55.7500 39.9167];           %[deg]
%   lon2 = [44.4333 37.7000 116.4333];          %[deg]
%   R = 6371;                                   %[km]
%   [dist, bearing, bearing2] = haversine(lat1, lon1, lat2, lon2, R);
%   Returns     dist:     10005.0204 7849.7892 11144.8652 [km]
%               bearing:     45.1828   32.7076   349.2181 [deg]
%               bearing2:   138.678   131.6973   190.9344 [deg]
%
% SOURCE DOCUMENTATION:
%	[1]    http://www.movable-type.co.uk/scripts/LatLong.html
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit haversine.m">haversine.m</a>
%	  Driver script: <a href="matlab:edit Driver_haversine.m">Driver_haversine.m</a>
%	  Documentation: <a href="matlab:pptOpen('haversine_Function_Documentation.pptx');">haversine_Function_Documentation.pptx</a>
%
% See also invhaversine, vincenty, invvincenty, CheckLatLon
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/369
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/haversine.m $
% $Rev: 2315 $
% $Date: 2012-03-07 12:26:05 -0600 (Wed, 07 Mar 2012) $
% $Author: g61720 $

function [dist, bearing, bearing2] = haversine(lat1, lon1, lat2, lon2, R)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam 'Output with filename included...' ]);
% disp([mfspc 'further outputs will be justified the same']);
% disp([mfspc 'CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam 'WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam 'ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam 'ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Initialize Outputs:
dist= -1;
bearing= -1;

%% Input Argument Conditioning:
if nargin < 4
   disp([mfnam ' :: Please refer to useage of haversine' endl ...
       'Syntax: [dist, bearing, bearing2] = haversine(lat1, lon1, '...
       'lat2, lon2, R)']);
   return;
end;

if nargin == 4
    R = 6378.1370;      % [km]   WGS-84 Earth Radius
end

if (isempty(lat1) || isempty(lon1) || isempty(lat2) || isempty(lon2) || ...
        isempty(R))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(lat1) || ischar(lon1) || ischar(lat2) || ischar(lon2) || ...
        ischar(R))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

% Double check inputs are within bounds:
[lat1, lon1] = CheckLatLon(lat1, lon1);
[lat2, lon2] = CheckLatLon(lat2, lon2);
dlat = lat2 - lat1; % [deg]
dlon = lon2 - lon1; % [deg]
%% Main Function:
R2D = 180.0/acos(-1);   % Radians to Degrees

%% Compute Relative Distance [user defined units]
a = ((sind(dlat/2)).^2) + (cosd(lat1)).*(cosd(lat2)).*((sind(dlon/2)).^2);
c = 2*atan2( sqrt(a), sqrt(1-a) );
dist = R .* c;

%% Compute Relative Bearing [deg]
bearing = atan2( sind(dlon).*cosd(lat2), ...
    cosd(lat1).*sind(lat2) - sind(lat1).*cosd(lat2).*cosd(dlon) ).*R2D;
%   Wrap Bearing to 0-360
bearing = mod(bearing + 360, 360);    % [deg]

%% Compute Final Bearing [deg]
dlon = lon1 - lon2;     % [deg]
bearing2 = atan2( sind(dlon).*cosd(lat1), ...
   cosd(lat2).*sind(lat1) - sind(lat2).*cosd(lat1).*cosd(dlon) ).*R2D +180;
bearing2 = mod(bearing2, 360);    % [deg]

end % << End of function haversine >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101007 JPG: Cleaned up the complicated error checking.
% 101006 JPG: Cleaned up the help header to only include 2 simple examples.
% 101004 JPG: Added example references.
% 100923 JPG: Modified the code to be able to take in vector and matrix
%             inputs.  Also added some error checking.
% 100921 JPG: Filled in the function according to CoSMO standard.
% 100921 CNF: Function template created using CreateNewFunc
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
