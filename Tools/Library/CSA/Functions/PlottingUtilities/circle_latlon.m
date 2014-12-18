% CIRCLE_LATLON Plots a circle of fixed range about a specified latitude/longitude point
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% circle_latlon:
%     Plots a fixed-range circle or circular arc about a geodetic latitude
%     and longitude point.  Due to the oblateness of a central body, the
%     regular 'circle' plot command cannot be used for geodetic circles.
%     For this function, the inverse vincenty function is used to compute
%     local latitude/longitude points about a reference centerpoint that
%     can be used to plot a lat/lon circle.
% 
% SYNTAX:
%	[h, arrLatLon] = circle_latlon(lat_c_deg, lon_c_deg, range, varargin, 'PropertyName', PropertyValue)
%	[h, arrLatLon] = circle_latlon(lat_c_deg, lon_c_deg, range, varargin)
%	[h, arrLatLon] = circle_latlon(lat_c_deg, lon_c_deg, range)
%	[h, arrLatLon] = circle_latlon(lat_c_deg, lon_c_deg)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	lat_c_deg	[1]         [deg]       Y coordinate (latitude) of 
%                                        circle's center
%	lon_c_deg	[1]         [deg]       X coordinate (longitude) of
%                                       circle's center
%	range   	[1]         [length]    Radius of the circle
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
% OUTPUTS: 
%	Name		Size		Units		Description
%	h   		[1]		    [ND]  		Line Handle
%   arrLatLon   [n x 2]     [deg]       [Latitude/Longitude] points
%                                        computed for circle
%
% NOTES:
%
%   VARARGIN PROPERTIES:
%   PropertyName    PropertyValue   Default         Description
%   'a'             [length]        20925646.32...* Central Body Semi-major Axis                
%   'f'             [ND]            1/298.257223563 Central Body Flattening Parameter
%   'StartAngle'    [deg]           0               Start Angle of Circle
%   'EndAngle'      [deg]           360             End Angle of Circle
%   'AngleStep'     [deg]           0.01            Circle Fineness
%   'Color'         'string'        'b'             Line Color
%   'LineWidth'     [double]        1               Line Width
%   'LineStyle'     'string'        '-'             Line Style
%   'PlotType'      'string'        'plot'          MATLAB function used to
%                                                    plot data.  Either
%                                                    'plot' or 'geoshow'.
%
%   *Note: If the Semi-major axis is not provided, Earth's WGS-84's
%   semi-major axis in ENGLISH (feet) will be used.  If the Central Body 
%   Flattening Parameter, f, is not provided, the WGS-84 flattening 
%   parameter is assumed.
%
% EXAMPLES:
%	% Example 1:
%   %   Plot a thick, red circle at 0 latitude, 0 longitude with a radius
%   %   of 1 mile.  Use the default Earth WGS-84 (English) parameters.
%   %   Note that [feet] are assumed so radius (1 mile) must be converted
%   %   to [feet]
%   figure();
%	[h] = circle_latlon(0, 0, 5280, 'r-', 'LineWidth', 2);
%   xlabel('\bfLonitude [deg]'); ylabel('\bfLatitude [deg]');
%   grid on; set(gca, 'FontWeight', 'bold');
%
%	% Example 2:
%   %   Plot just a portion of a thick, red circle at 0 latitude, 
%   %   0 longitude with a radius of 1 kilometer.  Use Lunar 
%   %   Metric central body parmaters.
%   %   Note that [meters] are the standard metric units so the radius
%   %   (1 km) must be converted to [meters]
%   %   Load in the Moon Parameters and conversions:
%   CB = CentralBodyMoon_init(1);   % Use 1 for metric
%   figure();
%	[h] = circle_latlon(0, 0, 1000, 'a', CB.a, 'f', CB.flatten, ...
%           'StartAngle', 0, 'EndAngle', 90, 'r-', 'LineWidth', 2);
%   xlabel('\bfLonitude [deg]'); ylabel('\bfLatitude [deg]');
%   grid on; set(gca, 'FontWeight', 'bold');
%
% SOURCE DOCUMENTATION:
%	[1]    http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
%	[2]    http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.ht
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit circle_latlon.m">circle_latlon.m</a>
%	  Driver script: <a href="matlab:edit Driver_circle_latlon.m">Driver_circle_latlon.m</a>
%	  Documentation: <a href="matlab:pptOpen('circle_latlon_Function_Documentation.pptx');">circle_latlon_Function_Documentation.pptx</a>
%
% See also invvincenty, circle 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/719
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/circle_latlon.m $
% $Rev: 2482 $
% $Date: 2012-09-21 12:43:01 -0500 (Fri, 21 Sep 2012) $
% $Author: sufanmi $

function [h, arrLatLon] = circle_latlon(lat_c_deg, lon_c_deg, range, varargin)

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
h= [];

%% Input Argument Conditioning:
[StartAngle, varargin]  = format_varargin('StartAngle', 0, 2, varargin);
[EndAngle, varargin]    = format_varargin('EndAngle', 360, 2, varargin);
[AngleStep, varargin]   = format_varargin('AngleStep', 0.01, 2, varargin);
[CB_a, varargin]        = format_varargin('a', [], 2, varargin);
[CB_f, varargin]        = format_varargin('f', [], 2, varargin);
[PlotType, varargin]   = format_varargin('PlotType', '', 2, varargin);

CB_default = CentralBodyEarth_init(0);  % WGS-84 (English) Defaults
if(isempty(CB_a))
    CB_a = CB_default.a;    % [ft]
end

if(isempty(CB_f))
    CB_f = CB_default.flatten;  % [ND]
end    

if(nargin < 3)
    errstr = [mfnam '>> ERROR: Must use at least 3 scalar inputs. See ' mlink ' help'];
    error([mfnam ':InputArgCheck'], 'Input must be a scalar.')
end

if(~isnumeric(lat_c_deg) || ~isnumeric(lon_c_deg) || ~isnumeric(range))
    errstr = [mfnam '>> ERROR: Inputs must be scalar. See ' mlink ' help'];
    error([mfnam ':InputArgCheck'], 'Input must be a scalar.')
end

%% Main Function:
arrAng = [StartAngle : AngleStep : EndAngle]';
[arrLat2, arrLon2] = invvincenty(lat_c_deg, lon_c_deg, arrAng, range, CB_a, CB_f);

if(strcmp(lower(PlotType), 'geoshow'))
    h = geoshow( arrLat2, arrLon2, varargin{:});
else
    h = plot(arrLon2, arrLat2, varargin{:});
end

arrLatLon(:,1) = arrLat2;   % [deg]
arrLatLon(:,2) = arrLon2;   % [deg]

end % << End of function circle_latlon >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110803 MWS: Created function using CreateNewFunc
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
