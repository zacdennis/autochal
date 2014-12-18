% LLA2ECI Converts Geodetic Latitude, Longitude, Altitude to Inertial Cartesian Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lla2eci:
%  Converts LLA (Geodetic Latitude / Longitude / Altitude) to 
%  Central Body Inertial and Central Body Fixed coordinates (e.g. ECI and
%  ECEF).
% 
% SYNTAX:
%	[P_i, P_f] = lla2eci(LLA, CB_f, CB_a, GMST_deg)
%	[P_i, P_f] = lla2eci(LLA, CB_f, CB_a)
%	[P_i, P_f] = lla2eci(LLA, CB_f)
%	[P_i, P_f] = lla2eci(LLA)
%
% INPUTS: 
%	Name    	Size	Units               Description
%   LLA         [3]   	[deg deg length]    Geodetic Latitude, Longitude, 
%                                           Altitude w.r.t. mean sea level
%   CB_f        [1]     [ND]                Central Body flattening parameter
%                                            Default:  1/298.257223563 [ND] (WGS-84)
%   CB_a        [1]     [length]            Central Body semi-major axis
%                                            Default: 6378137.0 [m] (WGS-84)
%   GMST_deg    [1]     [deg]               Greenwich mean sidereal time
%                                           (angle between vernal equinox
%                                            and Greenwich meridian (0 lon))
%                                            Default: 0
% OUTPUTS: 
%	Name    	Size	Units               Description
%   P_i         [3]     [dist]              Position in Central Body 
%                                           Inertial Frame
%   P_f         [3]     [dist]              Position in Central Body 
%                                           Fixed Frame
%
% NOTES:
%   This calculation is not unit specific.  Distanct inputs only need to be
%   of a uniform unit.  Standard METRIC [m] or ENGLISH [ft] distances
%   should be used.  'LLA' can be either a column or row vector.  'P_i'
%   will carry the same dimensions as 'LLA'.
%
%   If GMST_deg = 0, 'ECI' == 'ECEF'.  This function works for any central body.
%   If this was used for a moon simulation, it should be understood that 
%   'ECI' should be referred to as 'LCI', or "Lunar Centric Inertial".
%
% EXAMPLES:
%   % Define Constants for Examples:
%   CB_a = 6378137.0;        % [m]   Earth semi-major axis
%   CB_f = 1/298.257223563;  % [ND]  Earth CB_fing parameter
%   GMST_deg = 0;            % [deg] Mean sidereal time
%
%   % Example 1: Test lla2eci at 0/0 Lat/Lon (on equator/prime meridian)
%   LLA = [0 0 0];
%
%   [P_i] = lla2eci(LLA, CB_f, CB_a, GMST_deg)
%   % returns...
%   %   P_i = [6378137.00             0             0]
%
%   % Example 2: Test lla2eci at the north pole
%   LLA = [90 0 0];
%
%   [P_i] = lla2eci(LLA, CB_f, CB_a, GMST_deg)
%   % returns ...
%   %   P_i = [      0.00             0    6356752.31]
%
%   % Example 3: Test lla2eci at LAX
%   LLA(1) = 33.9425222;    % [deg] Geodetic Latitude
%   LLA(2) = -118.4071611;  % [deg] Longitude
%   LLA(3) = 100;           % [m]   Alitude w.r.t. Mean Sea Level
%
%	[P_i] = lla2eci(LLA, CB_f, CB_a, GMST_deg)
%   % returns ...
%   %   P_i = [  -2519918.02   -4659098.96    3541215.05 ]
%
%  SOURCE DOCUMENTATION
%   [1]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%           Simulation. 2nd Edition" New York: John Wiley & Sons, Inc. 2003.
%           Pages 36-38.
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit lla2eci.m">lla2eci.m</a>
%	  Driver script: <a href="matlab:edit Driver_lla2eci.m">Driver_lla2eci.m</a>
%	  Documentation: <a href="matlab:winopen(which('lla2eci_Function_Documentation.pptx'));">lla2eci_Function_Documentation.pptx</a>
%
% See also eci2lla 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/345
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/lla2eci.m $
% $Rev: 2989 $
% $Date: 2013-08-14 14:40:32 -0500 (Wed, 14 Aug 2013) $
% $Author: sufanmi $

function [P_i, P_f] = lla2eci(LLA, CB_f, CB_a, GMST_deg)

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
if( (nargin < 4) || isempty(GMST_deg) )
    GMST_deg = 0;
end
if( (nargin < 3) || isempty(CB_a) )
    CB_a = 6378137.0;              % [m]   Semi-major Axis (WGS-84)
end
if( (nargin < 2) || isempty(CB_f) )
    CB_f = 1/298.257223563;  % [ND]  CB_fing Parameter (WGS-84)
end

% Create a vector for P_i & P_f with same dimensions as LLA (either row or col)
P_i = LLA * 0;
P_f = P_i;

%% Process Inputs:
[GD_lat_deg, Lon_deg] = CheckLatLon(LLA(1), LLA(2));
D2R = acos(-1)/180.0;
Lat_rad     = GD_lat_deg * D2R;
Lon_rad     = Lon_deg * D2R;
h           = LLA(3);
GMST_rad    = GMST_deg * D2R;

%% Calculate Intermediate Variables:
%  Compute Square of Eccentricity
%   Ref 1: pg 36, Derivation of Eqn 1.4-1b & 1.4-1d
e2 = (2-CB_f)*CB_f;

% Compute Prime Vertical Radius of curvature, N
%   Ref 1: pg 38, Eqn 1.4-5
N = CB_a/(sqrt(1 - e2*sin(Lat_rad)*sin(Lat_rad)));

%% Convert LLA to ECEF frame:
%  Ref 1: pg 38, Eqn 1.4-8
P_f(1)  = (N+h)*cos(Lat_rad)*cos(Lon_rad);   % [dist]
P_f(2)  = (N+h)*cos(Lat_rad)*sin(Lon_rad);   % [dist]
P_f(3)  = (N*(1-e2) + h)*sin(Lat_rad);                  % [dist]

%% Convert ECEF to ECI Frame:
i_C_f  =    [...
    cos(GMST_rad) -sin(GMST_rad)    0;
    sin(GMST_rad)  cos(GMST_rad)    0;
    0               0               1];
if size(P_i, 1) == 3
    P_i = i_C_f * P_f;      % [dist]
else
    P_i = (i_C_f * P_f')';   % [dist]
end

end % << End of function lla2eci >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110307 MWS: Overloaded function to work if GMST_deg, a, or CB_f is not 
%               specified.  Added 3 internal examples and updated source
%               documentation to be the same as eci2lla for completeness.
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
