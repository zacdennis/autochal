% ECI2LLA Compute Geocentric Latitude, Geodetic Latitude, Longitude, and Geodetic Altitude from Earth Centered Inertial Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eci2lla:
%     Compute Geocentric Latitude, Geodetic Latitude, Longitude, and
%   Geodetic Altitude from Earth Centered Inertial Coordinates
% 
% SYNTAX:
%	[GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a, b, flatten, mst)
%	[GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a, b, flatten)
%   [GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a, b)
%   [GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a)
%   [GC_lat, GD_lat, lon, alt] = eci2lla(Peci)
%
% INPUTS: 
%	Name		Size		Units		Description
%	Peci        [1x3]       [length]    Position in Central Body Inertial Frame
%   a           [1x1]       [length]    Central body semi-major axis
%   b           [1x1]       [length]    Central Body Semi-minor axis
%   flatten     [1x1]       [ND]        Central Body Flattening Parameter
%   mst         [1x1]       [deg]       Mean Sidereal Time
%                                           Default: mst = 0
%                                                    a   = 6378137.0
%                                                    b   = 6356752.3142
%                                                flatten = 1/298.257223563   
% OUTPUTS: 
%	Name		Size		Units		Description
%	GC_lat      [1x1]       [deg]       Geocentric Latitude
%   GD_lat      [1x1]       [deg]       Geodetic Latitude
%   lon         [1x1]       [deg]       Longitude
%   alt         [1x1]       [length]    Geodetic Altitude
%
% NOTES:
%   This calculation is not unit specific.  Output distance will be of same
%  units as input distances.  Standard METRIC [m] or ENGLISH [ft] distance
%  should be used. 
%
%   If the Central Body Semi-major axis 'a', Semi-minor axis 'b', and
%  flattening parameter 'flatten' are not specified, METRIC WGS-84 
%  Earth parameters are assumed. mst is assumed to be zero if not specified.
%
% EXAMPLES:
%	Example 1: An aircraft is [100 200 68000000] position in the eci frame. Use
%	default values to find the latitude and longitude (Default Values).
%   Peci=[100 200 68000000]
% 	[GC_lat, GD_lat, lon, alt] = eci2lla(Peci)
%	Return GC_lat= 89.9981; GD_lat= 89.9981; lon= 63.4349; alt= 4.4325e+005;
%
%	Example 2: Given Peci=[10^7 5*10^7 6*10^7] and mst=60. Also, using the
%	defaul values of earth as a central body for a, b and flatten, Find de
%	coordinates in longitude, latitude and altitude format.
%    a   = 6378137.0;b   = 6356752.3142; flatten = 1/298.257223563;
% 	[GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a, b, flatten, mst)
%	Return GC_lat = [49.4663]; GD_lat = [49.6563]; lon =[18.6901]; 
%   alt =[7.2374e+007]
%
% SOURCE DOCUMENTATION:
%	[1]    Borkowski, K.M. "Accurate Algorithms to Transform Geocentric to
%   Geodetic Coordinates"  Torun Radio Astronomy Observatory, Nicolaus
%   Copernicaus University, ul. Chopina 12/18, PL-87-100 Torun, Poland
%   Bullentin Geodesique, 63 (1989), pp. 50-56
%     http://www.astro.uni.torun.pl/~kb/Papers/geod/Geod-BG.htm
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eci2lla.m">eci2lla.m</a>
%	  Driver script: <a href="matlab:edit Driver_eci2lla.m">Driver_eci2lla.m</a>
%	  Documentation: <a href="matlab:pptOpen('eci2lla_Function_Documentation.pptx');">eci2lla_Function_Documentation.pptx</a>
%
% See also lla2eci eci2ned eci2ecef 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/326
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eci2lla.m $
% $Rev: 3031 $
% $Date: 2013-10-16 17:12:13 -0500 (Wed, 16 Oct 2013) $
% $Author: sufanmi $

function [GC_lat, GD_lat, lon, alt] = eci2lla(Peci, a, b, flatten, mst)

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
if ischar(Peci)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
%% Constants
R2D = 180.0/acos(-1);
D2R = acos(-1)/180.0;

if nargin == 1
    %% WGS-84 Four Defining Parameters
    a       = 6378137.0;        % [m]   Semi-major Axis
    flatten = 1/298.257223563;  % [ND]  Flattening Parameter
    b       = 6356752.3142;     % [m]   Semi-minor axis
    mst=0;
end
if nargin < 5
    mst = 0;
end
if nargin < 4
     flatten = 1/298.257223563;
end
if nargin < 3
     b = 6356752.3142;
end

X = Peci(1);
Y = Peci(2);
Z = Peci(3);

%% Compute Geodetic Latitude & Geodetic Altitude ==========================
r = sqrt( X*X + Y*Y );

%% Divide By Zero Check
if (abs(r) <= 1e-6)
    phi = sign(Z) * acos(-1)/2;
    h = abs(Z) - b;

else
    if (Z < 0)
        b = -b;
    end

    E = ((b*Z) - (a*a - b*b))/(a*r);        % {Eq 10}
    F = ((b*Z) + (a*a - b*b))/(a*r);        % {Eq 11}

    P = (4/3)*(E*F + 1);                    % {Eq 16}
    Q = 2*(E*E - F*F);                      % {Eq 17}

    D = (P*P*P) + (Q*Q);                    % {Eq 15}
    if (D < 0)
        v = 2*(sqrt(-P))*cos( (1/2)*acos(Q/((-P)^(3/2))) );     % {Eq 14b}
    else
        v = ((sqrt(D) - Q)^(1/3)) - ((sqrt(D) + Q)^(1/3));      % {Eq 14a}
    end

    G = (sqrt(E*E + v) + E)/2;              % {Eq 13}
    t = sqrt( G*G + (F-v*G)/(2*G-E)) - G;   % {Eq 12}

    phi = atan( a*(1-t*t)/(2*b*t) );        % {Eq 18}

    h = (r-a*t)*cos(phi) + (Z-b)*sin(phi);  % {Eq 19}
end

GD_lat = phi * R2D;
alt = h;

%% Compute Longitude ======================================================
lon = atan2( Y, X ) * R2D - mst;

%% Wrap Longitude to be within +/- 180
lon = mod(lon, 360.0);
if lon > 180.0
    lon = lon - 360.0;
end

%% Compute Geocentric Latitude ============================================
%   Geocentric Latitude {deg}
GC_lat = atan((1 - flatten)^2 * tan(GD_lat * D2R)) * R2D;

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/R2C.m
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
