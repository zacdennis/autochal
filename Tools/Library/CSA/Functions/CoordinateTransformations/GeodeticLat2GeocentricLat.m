% GEODETICLAT2GEOCENTRICLAT Computes Geocentric Latitude from Geodetic Latitude
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GeodeticLat2GeocentricLat:
%     Computes Geocentric Latitude from Geodetic Latitude
% 
% SYNTAX:
%	[GeocentricLat_deg] = GeodeticLat2GeocentricLat(GeodeticLat_deg, CB_flatten)
%	[GeocentricLat_deg] = GeodeticLat2GeocentricLat(GeodeticLat_deg)
%
% INPUTS: 
%	Name                Size    Units		Description
%	GeodeticLat_deg     [n]     [deg]       Geodetic Latitude
%   CB_flatten          [1]     [ND]        Central Body flattening parameter
%                                            Default:  1/298.257223563 for
%                                            WGS-84                              
% OUTPUTS: 
%	Name             	Size	Units		Description
%	GeocentricLat_deg	[n]     [deg]       Geocentric Latitude
%
% NOTES:
%   'GeodeticLat_deg' can be either a scalar, row vector, or column vector.
%   Outputted 'GeocentricLat_deg' will be the same size as input.
%
% EXAMPLES:
%	% Find Geocentric Latitude for Various Geodetic Latitudes.  Use WGS-84
%   %	default.
%   GeodeticLat_deg = [0 30 45 60 90];
%	[GeocentricLat_deg] = GeodeticLat2GeocentricLat(GeodeticLat_deg)
%   % returns:
%   %   GeocentricLat_deg = [0   29.8336   44.8076   59.8331   90.0000]
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
%	Source function: <a href="matlab:edit GeodeticLat2GeocentricLat.m">GeodeticLat2GeocentricLat.m</a>
%	  Driver script: <a href="matlab:edit Driver_GeodeticLat2GeocentricLat.m">Driver_GeodeticLat2GeocentricLat.m</a>
%	  Documentation: <a href="matlab:winopen(which('GeodeticLat2GeocentricLat_Function_Documentation.pptx'));">GeodeticLat2GeocentricLat_Function_Documentation.pptx</a>
%
% See also lla2eci, RadiusAtGeodeticLat 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/793
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/GeodeticLat2GeocentricLat.m $
% $Rev: 2905 $
% $Date: 2013-02-20 18:56:43 -0600 (Wed, 20 Feb 2013) $
% $Author: sufanmi $

function [GeocentricLat_deg] = GeodeticLat2GeocentricLat(GeodeticLat_deg, CB_flatten)

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
if( (nargin < 2) || isempty(CB_flatten) )
    CB_flatten = 1/298.257223563;  % [ND]  CB_flattening Parameter (WGS-84)
end

%% Main Function:
GeocentricLat_deg = atand((1 - CB_flatten)^2 * tand(GeodeticLat_deg));

end % << End of function GeodeticLat2GeocentricLat >>

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
