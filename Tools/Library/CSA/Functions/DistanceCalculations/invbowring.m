% INVBOWRING Computes the distance between two geodetic points using Bowring's formula
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% invbowring:
%     Computes the distance between Two Geodetic Latitude / Longitude
%     points using B.R. Bowring's equations.  The solution is direct
%     (non-iterative), and are valid for distances up to 150 km
%     (~492,126 ft or ~81 nautical miles)
% 
% SYNTAX:
%	[dist, az1to2_i_deg, az1to2_f_deg] = invbowring(lat1_deg, lon1_deg, lat2_deg, lon2_deg, CB_a, CB_ecc)
%	[dist, az1to2_i_deg, az1to2_f_deg] = invbowring(lat1_deg, lon1_deg, lat2_deg, lon2_deg, CB_a)
%
% INPUTS: 
%	Name            Size		Units		Description
%	lat1_deg        [1]         [deg]       Geodetic Latitude of Origin (Point #1)
%	lon1_deg        [1]         [deg]       Longitude of Origin (Point #1)
%	lat2_deg        [1]         [deg]       Geodetic Latitude of Destination (Point #2)
%	lon2_deg        [1]         [deg]       Longitude of Destination (Point #2)
%	CB_a            [1]         [length]    Central Body Semi-major Axis
%                                            Default: 6378137.0 [m] (WGS-84)
%	CB_ecc          [1]         [ND]        Central Body 1st Eccentricity
%                                            Default: 8.1819190842622e-2 [ND] (WGS-84)
%
% OUTPUTS: 
%	Name            Size		Units		Description
%	dist            [1]         [length]    Distance along Ellipsoid
%                                            between Origin to Destination
%	az1to2_i_deg	[1]         [deg]       Initial bearing from Point #1
%                                            towards Point #2, (0 degrees 
%                                            is due North, positive 
%                                            rotation towards East)
%	az1to2_f_deg	[1]         [deg]       Final bearing from Point #1
%                                            towards Point #2
%
% NOTES:
%   This calculation is not unit specific.  Output distance will be of same
%   units as input distances.  Standard METRIC [m] or ENGLISH [ft] distance
%   should be used.
%
% EXAMPLES:
%	% Example 1: Simple Polar Example using WGS-84 Parameters in Metric
%   lat1_deg =  89.9;               % [deg]
%   lon1_deg =   0.0;               % [deg]
%   lat2_deg =  89.9;               % [deg]
%   lon2_deg = 180.0;               % [deg]
%   CB_a     = 6378137.0;           % [m]
%   CB_ecc   = 0.081819190842622;   % [non-dimensional]
%	[dist, az1to2_i_deg, az1to2_f_deg] = invbowring(lat1_deg, lon1_deg, lat2_deg, lon2_deg, CB_a, CB_ecc)
%   % Returns (using 'format long g'):
%   % dist: 22338.2951250174                % [m]   <- Valid since <150 km
%   % az1to2_i_deg: 2.78616590096204e-012   % [deg]
%   % az1to2_f_deg: 179.999999999997        % [deg]
%   
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [x]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% [1]   http://en.wikipedia.org/wiki/Geographical_distance
% [2]   http://www.ferris.edu/faculty/burtchr/sure452/notes/direct-inverse.pdf
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit invbowring.m">invbowring.m</a>
%	  Driver script: <a href="matlab:edit Driver_invbowring.m">Driver_invbowring.m</a>
%	  Documentation: <a href="matlab:pptOpen('invbowring_Function_Documentation.pptx');">invbowring_Function_Documentation.pptx</a>
%
% See also vincenty, haversine 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/717
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/invbowring.m $
% $Rev: 2066 $
% $Date: 2011-07-28 20:40:01 -0500 (Thu, 28 Jul 2011) $
% $Author: sufanmi $

function [dist, az1to2_i_deg, az1to2_f_deg] = invbowring(lat1_deg, lon1_deg, lat2_deg, lon2_deg, CB_a, CB_ecc)

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

%% Transformations:
D2R = acos(-1)/180.0;   % [deg] to [rad]
R2D = 180.0/acos(-1);   % [rad] to [deg]

%% Condition Input Arguments:
if((nargin < 6) || isempty(CB_ecc))
    CB_ecc = 8.1819190842622e-2;   % [ND] First Eccentricity (WGS-84)
end

if((nargin < 5) || isempty(CB_a))
    CB_a = 6378137.0;   % [m]       Semi-major Axis (WGS-84)
end

% Enforce Positive Semi-major axis
CB_a = abs(CB_a);

% Enforce Ellipsoidal eccentricity (0 <= ecc < 1)
CB_ecc = max(CB_ecc, 0);
CB_ecc = min(CB_ecc, 1-eps);

CB_e2 = CB_ecc * CB_ecc;     % [ND]   Eccentricity Squared

% Ensure that Lat is within +/- 90 deg and Long is within +/-180 deg:
[lat1_deg, lon1_deg] = CheckLatLon(lat1_deg, lon1_deg);
[lat2_deg, lon2_deg] = CheckLatLon(lat2_deg, lon2_deg);

lat1_rad = lat1_deg * D2R;  % [rad]
lon1_rad = lon1_deg * D2R;  % [rad]
lat2_rad = lat2_deg * D2R;  % [rad]
lon2_rad = lon2_deg * D2R;  % [rad]

%% Main Function:
% Common Equations on [2], PDF pg 1:
cos_lat1_pow2 = cosd(lat1_deg) * cosd(lat1_deg);
cos_lat1_pow4 = cos_lat1_pow2 * cos_lat1_pow2;
A = sqrt( 1 + CB_e2 * cos_lat1_pow4 );
B = sqrt( 1 + CB_e2 * cos_lat1_pow2 );
C = sqrt( 1 + CB_e2 );
w = (A/2) * ( lon2_rad - lon1_rad );

% Inverse Problem Equations on [2], PDF pg 2:
delta_lat_rad = lat2_rad - lat1_rad;
D_sin_part = sin(2 * lat1_rad + (2/3)*delta_lat_rad);
D_bracket = 1 + (3*CB_e2 / (4*B*B)) * delta_lat_rad * D_sin_part;
D = delta_lat_rad / (2*B) * D_bracket;
E = sin(D) * cos(w);
F = (1/A) * ( sin(w) ) * (B*cos(lat1_rad)*cos(D) - sin(lat1_rad)*sin(D));
G = atan2(F, E);
sigma = 2 * asin(sqrt(E*E + F*F));
H = atan( (1/A)*(sin(lat1_rad) + B*cos(lat1_rad)*tan(D))*tan(w) );

% Inverse Geodetic Values, Azimuth and Distance on [2], PDF pg 3:
az1to2_f_deg    = (G - H) * R2D;    % [deg]
az1to2_i_deg  = (G + H) * R2D;    % [deg]
dist = CB_a * C * sigma / (B * B);      % [dist]

end % << End of function invbowring >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110728 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                 : NGGN Username 
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

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
