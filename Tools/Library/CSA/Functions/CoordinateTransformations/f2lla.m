% F2LLA Computes Geocentric & Geodeic Latitude, Longitude, and Altitude from Central Body Fixed Coordinates
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% f2lla:
%   Computes Geocentric & Geodeic Latitude, Longitude, and Altitude
%   from Central Body Fixed Coordinates.  Function uses an iterative method
%   to compute an EXACT solution.
%
% SYNTAX:
%	[GD_lat_deg, Lon_deg, Alt_msl, GC_lat_deg] = f2lla(P_f, CB_a, CB_flatten)
%	[GD_lat_deg, Lon_deg, Alt_msl, GC_lat_deg] = f2lla(P_f, CB_a)
%	[GD_lat_deg, Lon_deg, Alt_msl, GC_lat_deg] = f2lla(P_f)
%
% INPUTS:
%	Name      	Size		Units		Description
%	P_f 	    [3]         [length]    Position in Central Body Fixed
%                                        Frame (e.g. ECEF, LCLF)
%	CB_a	    [1]         [length]    Central body semi-major axis
%                                        Default: 6378137.0 [m] (WGS-84)
%	CB_flatten	[1]         [ND]        Central Body Flattening Parameter
%                                        Default: 1/298.257223563 (WGS-84)
%
% OUTPUTS:
%	Name      	Size		Units		Description
%	GD_lat_deg	[1]         [deg]       Geodetic Latitude
%	Lon_deg     [1]         [deg]       Longitude
%	Alt_msl 	[1]         [length]    Altitude above mean sea level
%	GC_lat_deg	[1]         [deg]       Gecentric Latitude
%
% NOTES:
%   This calculation is not unit specific.  Output distance will be of same
%  units as input distances.  Standard METRIC [m] or ENGLISH [ft] distance
%  should be used.
%
% EXAMPLES:
%	% Reproduce Vallado's Example 3-3.  Note Example uses METRIC [m]
%   P_f_m      = [6524834; 6862875; 6448296];   % [m]
%   CB_a_m     = 6378137.0;                     % [m]  WGS-84
%   CB_flatten = 1/298.257223563;               % [ND] WGS-84
%	[GD_lat_deg, Lon_deg, Alt_msl_m, GC_lat_deg] = f2lla(P_f_m, CB_a_m, CB_flatten)
%   % returns:
%   %   GD_lat_deg  = 34.3524951508616 [deg]
%   %   Lon_deg     = 46.44641685679   [deg]
%   %   Alt_msl_m   = 5085218.73109163 [m]
%   %   GC_lat_deg  = 34.1734283554891 [deg]
%
% SOURCE DOCUMENTATION:
% [1]   Vallado, David A.  Fundamentals of Astrodynamics and Applications,
%        3rd Edition.  Hawthorne, CA: Micorcosm Press, 2007.
%        Section 3.4.4 (pages 176-180), Section 1.2.1 (pages 14-16)
%        Also see 'ijk2ll.m' from www.microcosminc.com/Vallado (Matlab
%        link)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit f2lla.m">f2lla.m</a>
%	  Driver script: <a href="matlab:edit Driver_f2lla.m">Driver_f2lla.m</a>
%	  Documentation: <a href="matlab:winopen(which('f2lla_Function_Documentation.pptx'));">f2lla_Function_Documentation.pptx</a>
%
% See also lla2eci
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/799
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/f2lla.m $
% $Rev: 2937 $
% $Date: 2013-04-04 14:41:40 -0500 (Thu, 04 Apr 2013) $
% $Author: sufanmi $

function [GD_lat_deg, Lon_deg, Alt_msl, GC_lat_deg] = f2lla(P_f, CB_a, CB_flatten)

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
% Pick out Properties Entered via varargin
if( (nargin < 3) || isempty(CB_flatten) )
    CB_flatten  = 1/298.257223563;  % [ND]  Flattening Parameter (WGS-84)
end

if( (nargin < 2) || isempty(CB_a) )
    CB_a        = 6378137.0;        % [m]   Semi-major Axis (WGS-84)
end

%% Main Function:
R2D = 180.0/acos(-1);
CB_e2 = CB_flatten*(2-CB_flatten);   % Eccentricity^2 (Eq 1-6, pg 16)

% Algorithm 12: ECEF to LatLon, pg 179
% Convert to Central Body Radii
r_i = P_f(1);                   % [length]
r_j = P_f(2);                   % [length]
r_k = P_f(3);                   % [length]
r_ij = sqrt(r_i*r_i + r_j*r_j); % [length]

% Compute Longitude
Lon_deg = atan2(r_j, r_i)*R2D;  % [deg]
GD_lat_rad = 0;                 % Initialize
small_dist = 1e-8;              % [length]
Cref_num = CB_a;                % [length] Numerator for Cref

if(r_ij < small_dist)
    % Special case, at/near pole:
    r_ijk       = sqrt(r_i*r_i + r_j*r_j + r_k*r_k);    % [length]
    GD_lat_rad  = asin( r_k / r_ijk );                  % [rad]
    GD_lat_deg  = GD_lat_rad * R2D;                     % [deg]
    
    % Compute Radius of curvature in the meridian, Cref
    sin_GD_lat = sin(GD_lat_rad);
    Cref_den = sqrt( 1 - (CB_e2*sin_GD_lat*sin_GD_lat) );
    Cref = Cref_num / Cref_den;                         % [length]
    Sref = Cref * (1-CB_e2);                            % [length]
    Alt_msl = r_ijk/sin_GD_lat - Sref;                  % [length]
    
else
    tan_delta = r_k / r_ij;
    GD_lat_old_rad = atan(tan_delta);
    
    maxLoops = 20;
    tol_rad = 1e-15;
    
    % Figure out Geodetic Latitude
    iLoop = 0;
    flgTolSatisfied =  false;
    while( (~flgTolSatisfied) && (iLoop < maxLoops) )
        iLoop = iLoop + 1;
        sin_GD_lat = sin(GD_lat_old_rad);
        
        % Compute Radius of curvature in the meridian, Cref
        Cref_den = sqrt( 1 - (CB_e2*sin_GD_lat*sin_GD_lat) );
        Cref = Cref_num / Cref_den;                         % [length]
        
        tan_GD_lat =  (r_k + (Cref * CB_e2 * sin_GD_lat))/r_ij;
        GD_lat_rad = atan(tan_GD_lat);                      % [rad]
        delta_GD_lat_rad = (GD_lat_rad - GD_lat_old_rad);   % [rad]
        flgTolSatisfied = delta_GD_lat_rad < tol_rad;       % [bool]
        GD_lat_old_rad = GD_lat_rad;                        % [rad]
    end
    GD_lat_deg = GD_lat_rad * R2D;                          % [deg]
    
    % Compute Alt_msl
    sin_GD_lat = sin(GD_lat_rad);
    Cref_den = sqrt( 1 - (CB_e2*sin_GD_lat*sin_GD_lat) );
    Cref = Cref_num / Cref_den;                             % [length]
    
    Alt_msl = (r_ij / (cos(GD_lat_rad))) - Cref;            % [length]
end

%% Compute Geocentric Latitude ============================================
%   Geocentric Latitude {deg}
GC_lat_deg = atan( (1 - CB_e2)*tan(GD_lat_rad) ) * R2D;     % [deg]

end % << End of function f2lla >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130403 MWS: Created function using CreateNewFunc
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
%   subject to severe civil and/or criminal penAlt_mslies.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
