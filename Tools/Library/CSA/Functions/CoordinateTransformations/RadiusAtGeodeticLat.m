% RADIUSATGEODETICLAT Computes Ellipsoidal Radius for a Geodetic Latitude
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% RadiusAtGeodeticLat:
%     Computes Ellipsoidal Radius for a Geodetic Latitude.  Also computes
%     meridian radius of curvature (R_N) and transverse radius of curvature
%     (R_E).
% 
% SYNTAX:
%	[Radius, R_N, R_E] = RadiusAtGeodeticLat(GeodeticLat_deg, CB_flatten, CB_a)
%	[Radius, R_N, R_E] = RadiusAtGeodeticLat(GeodeticLat_deg, CB_flatten)
%	[Radius, R_N, R_E] = RadiusAtGeodeticLat(GeodeticLat_deg)
%
% INPUTS: 
%	Name           	Size    Units		Description
%	GeodeticLat_deg [n]     [deg]       Geodetic Latitude
%   CB_flatten      [1]     [ND]        Central Body flattening parameter
%                                        Default:  1/298.257223563 (WGS-84)
%   CB_a            [1]     [length]    Central Body semi-major axis
%                                        Default: 6378137.0 [m] (WGS-84)
% OUTPUTS: 
%	Name           	Size	Units		Description
%	Radius	        [n]     [length]    Ellipsoidal radius at latitude
%   R_N             [n]     [length]    Meridian radius of curvature
%   R_E             [n]     [length]    Transverse (prime vertical) radius 
%                                        of curvature
%
% NOTES:
%   This calculation is not unit specific.  Semi-major axis should be in
%   standard METRIC [m] or ENGLISH [ft] distances.  Outputted 'Radius' will
%   carry same used as 'CB_a'. 'GeodeticLat_deg' can be either a scalar, 
%   row vector, or column vector.  Outputted 'Radius' will be the same size
%   as 'GeodeticLat_deg'.
%
% EXAMPLES:
%	% Find the Reference Radius for Various Geodetic Latitudes.  Use the
%   %	WGS-84 default.  Note that output radius will be in [m].
%   format long g
%   GeodeticLat_deg = [0 30 45 60 90]';
%	[Radius] = RadiusAtGeodeticLat(GeodeticLat_deg)
%   % returns:
%   %   Radius = [  6378137
%   %               6372824.42029401
%   %               6367489.54386347
%   %               6362132.2243971
%   %               6356752.31424518 ]
%   %   Note WGS-84 Semi-minor Axis (b) is earth.b is 6356752.3142 [m]
%
% SOURCE DOCUMENTATION:
%	[1]    Borkowski, K.M. "Accurate Algorithms to Transform Geocentric to
%   Geodetic Coordinates"  Torun Radio Astronomy Observatory, Nicolaus
%   Copernicaus University, ul. Chopina 12/18, PL-87-100 Torun, Poland
%   Bullentin Geodesique, 63 (1989), pp. 50-56
%     http://www.astro.uni.torun.pl/~kb/Papers/geod/Geod-BG.htm
%
%   [2]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%   Simulation." New York: John Wiley & Sons, Inc. 1992.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit RadiusAtGeodeticLat.m">RadiusAtGeodeticLat.m</a>
%	  Driver script: <a href="matlab:edit Driver_RadiusAtGeodeticLat.m">Driver_RadiusAtGeodeticLat.m</a>
%	  Documentation: <a href="matlab:winopen(which('RadiusAtGeodeticLat_Function_Documentation.pptx'));">RadiusAtGeodeticLat_Function_Documentation.pptx</a>
%
% See also lla2eci, GeodeticLat2GeocentricLat 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/794
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/RadiusAtGeodeticLat.m $
% $Rev: 2916 $
% $Date: 2013-03-14 20:23:03 -0500 (Thu, 14 Mar 2013) $
% $Author: sufanmi $

function [Radius, R_N, R_E] = RadiusAtGeodeticLat(GeodeticLat_deg, CB_flatten, CB_a)

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

%% Input Argument Conditioning:
if( (nargin < 3) || isempty(CB_a) )
    CB_a = 6378137.0;              % [m]   Semi-major Axis (WGS-84)
end

if( (nargin < 2) || isempty(CB_flatten) )
    CB_flatten = 1/298.257223563;  % [ND]  CB_flattening Parameter (WGS-84)
end

%% Main Function:

% Compute Eccentricity
CB_e = sqrt( (CB_flatten * (2-CB_flatten) ) );

% Compute Meridian Radius of Curvature & Prime Vertical R
%   Ref 2: Equation 1.4-3, pg 37 & Equation 1.4-5, pg 38
den1 = 1 - ((CB_e*sind(GeodeticLat_deg))^2);
R_N = (CB_a*(1-CB_e^2)) / den1^(3/2);   % Ref 2: Eq. 1.4-3, pg 37
R_E = (CB_a/sqrt(den1));                % Ref 2: Eq. 1.4-5, pg 37

[GeocentricLat_deg] = GeodeticLat2GeocentricLat(GeodeticLat_deg, CB_flatten);
Radius = sqrt(CB_a^2 ./ (1 + ((1 ./ (1 - CB_flatten)^2) - 1) .* (sind(GeocentricLat_deg)).^2));

end % << End of function RadiusAtGeodeticLat >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130220 MWS: Created Function based on lla2eci
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
