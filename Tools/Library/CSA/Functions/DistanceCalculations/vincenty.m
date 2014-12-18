% VINCENTY Computes the distance between two geodetic points (oblate)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vincenty:
%   Computes the distance between Two Geodetic Latitude / Longitude Points.
%   User define the points, and some geometric parameters(
%   The distance is commonly referred to as the 'as-the-crow-flies'
%   distance. This function assumes that the Central Body is an oblate
%   spheroid.
% 
% SYNTAX:
%	[dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f, flgRunToMax, maxCtr)
%	[dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f, flgRunToMax)
%	[dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f)
%	[dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a)
%	[dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg)
%
% INPUTS: 
%	Name		Size		Units		Description
%   lat1_deg    [Variable]  [deg]       Geodetic Latitude of Origin 
%                                       (Point #1)
%   lon1_deg    [Variable]  [deg]       Longitude of Origin (Point #1)
%   lat2_deg    [Variable]  [deg]       Geodetic Latitude of Destination 
%                                       (Point #2)
%   lon2_deg    [Variable]  [deg]       Longitude of Destination 
%                                       (Point #2)
%   a           [1]         [length]    Central Body Semi-major Axis
%                                        Default: 6378137.0 [m] (WGS-84)
%   f           [1]         [ND]        Central Body Flattening Parameter
%                                        Default: 1/298.257223563 [ND] (WGS-84)
%   flgRunToMax [1]         [bool]      Enforce hard limit on number of
%                                       iterations to use?
%                                        Default: 0 (no)
%   maxCtr      [1]         [int]       Maximum number of iterations to use
%                                        for convergence
%                                        Default: 20
% OUTPUTS: 
%	Name		Size		Units		Description
%   dist        [Variable]  [length]    Distance to travel along Spheroid 
%                                       from Origin to Destination
%   azimuth1_deg [Variable] [deg]       Initial Bearing from Point #1 
%                                       towards Point #2, (0 degrees is 
%                                       due North, positive rotation 
%                                       towards East)
%   azimuth2_deg [Variable] [deg]       Final Bearing from Point #1 towards
%                                       Point #2, (0 degrees is due North,
%                                       positive rotation towards East)
%   ctr_int     [Variable]  [int]       Iterations used to converge on
%                                        solution
%
% NOTES:
%   This calculation is not unit specific.  Output distance will be of same
%   units as input distances.  Standard METRIC [m] or ENGLISH [ft] distance
%   should be used.
%   Inputs should have the same dimensions, which can be scalar
%	([1]), a vector ([1xN] or [Nx1]), or a multi-dimensional matrix 
%   (M x N x P x ...]).  The outputs will carry the same dimensions as the 
%   inputs.
%
% EXAMPLES:
%   % Example 1: Singular Inputs
%   % A simple case which runs vincenty with all scalar arguments. The origin
%   % is Manila, Philippines and the destination is San Fransisco, USA.
% 
%   lat1_deg = 14.5833;     % [deg]
%   lon1_deg = 120.9833;    % [deg]
%   lat2_deg = 37.75;       % [deg]
%   lon2_deg = -122.68;      % [deg]
%   a = 6371;               % [km]  WGS-84
%   f = 1/298.257;          % [ND]  WGS-84
%   [dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f);
%   % Returns:
%   % dist:           11198.256  [km]
%   % azimuth1_deg:      46.147  [deg]
%   % azimuth2_deg:     118.151  [deg]
%   %      ctr_int:           4  [int]
%
%   % Example 2: Vector Case
%   % Running a mixed case, with a single origin and multiple destinations.
%   % The origin is approximately Washington DC, USA.  The three destinations
%   % are Baghdad, Iraq, Moscow, Russia, and Beijing, China respectively.
% 
%   lat1_deg = 38.95;                           % [deg]
%   lon1_deg = -77.46;                          % [deg]
%   lat2_deg = [33.3333 55.7500 39.9167];       % [deg]
%   lon2_deg = [44.4333 37.7000 116.4333];      % [deg]
%   a = 6371;                                   % [km] WGS-84
%   f = 1/298.257;                              % [ND] WGS-84
%   [dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f);
%   % Returns:
%   % dist:          10004.254  [km]   7853.289  [km]  11144.993  [km] 
%   % azimuth_deg:      45.136  [deg]    32.721  [deg]   349.234  [deg]
%   % azimuth2_deg:    138.703  [deg]   131.736  [deg]   190.918  [deg]
%   % ctr_int:               5  [int]         4  [int]         5  [int]
%
%   % Example 3: Run the Vector Case (Example for the maximum number of 
%   % iterations.
%   %   [dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, lon1_deg, lat2_deg, lon2_deg, a, f, 1);
%   % Returns:
%   % dist:          10004.254  [km]   7853.289  [km]  11144.993  [km] 
%   % azimuth_deg:      45.136  [deg]    32.721  [deg]   349.234  [deg]
%   % azimuth2_deg:    138.703  [deg]   131.736  [deg]   190.918  [deg]
%   % ctr_int:              20  [int]        20  [int]        20  [int]
%
% SOURCE DOCUMENTATION:
%    [1] http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
%    [2] http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.html
%    [3] http://www.movable-type.co.uk/scripts/LatLongVincenty.html
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vincenty.m">vincenty.m</a>
%	  Driver script: <a href="matlab:edit Driver_vincenty.m">Driver_vincenty.m</a>
%	  Documentation: <a href="matlab:pptOpen('vincenty_Function_Documentation.pptx');">vincenty_Function_Documentation.pptx</a>
%
% See also INVVINCENTY, HAVERSINE, INVHAVERSINE
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/373
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/vincenty.m $
% $Rev: 2315 $
% $Date: 2012-03-07 12:26:05 -0600 (Wed, 07 Mar 2012) $
% $Author: g61720 $

function [dist, azimuth1_deg, azimuth2_deg, ctr_int] = vincenty(lat1_deg, ...
    lon1_deg, lat2_deg, lon2_deg, a, f, flgRunToMax, maxCtr)

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
% dist = 0;
% azimuth1_deg = 0;
% azimuth2_deg = 0;
% ctr = 0;

%% Input Argument Conditioning:
if nargin < 4
   disp([mfnam ' :: Please refer to useage of vincenty' endl ...
       'Syntax: [dist, azimuth1_deg, azimuth2_deg] = invvincenty(lat1_deg, lon1_deg, '...
       'lat2_deg, lon2_deg, a, f)']);
   return;
end;

if((nargin < 5) || isempty(a))
    % WGS-84 Earth Parameters
    a = 6378137.0;          % [m]   Semi-major Axis
end

if((nargin < 6) || isempty(f))
    % WGS-84 Earth Parameters
    f = 1/298.257223563;    % [ND]  Flattening Factor
end

if((nargin < 7) || isempty(flgRunToMax))
    flgRunToMax = 0;
end

if((nargin < 8) || isempty(maxCtr))
    maxCtr = 20;
end
maxCtr = round(maxCtr);     % Ensure maxCtr is an integer
maxCtr = max(maxCtr, 1);    % Ensure maxCtr is >= 1

if (isempty(lat1_deg) || isempty(lon1_deg) || isempty(lon2_deg) || isempty(lat2_deg)...
        || isempty(a) || isempty(f))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(lat1_deg) || ischar(lon1_deg) || ischar(lon2_deg) || ischar(lat2_deg) || ...
        ischar(a) || isempty(f))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (numel(a) ~= 1) || numel(f) ~= 1
    errstr = [mfnam tab 'ERROR: Ellipsoid parameters are not of dimension [1]'];
    error([mfnam 'Error:vincenty:dimension'], errstr);
end

[lat1_deg, lon1_deg] = CheckLatLon(lat1_deg, lon1_deg);
[lat2_deg, lon2_deg] = CheckLatLon(lat2_deg, lon2_deg);

%% Conversions
R2D     = 180.0/acos(-1);   % Radians to Degrees
D2R     = acos(-1)/180.0;   % Degrees to Radians

%% Main Function:
if numel(lat2_deg) ~= numel(lat1_deg)
    lat2_deg = lat2_deg.*ones(size(lat1_deg));
    lat1_deg = lat1_deg.*ones(size(lat2_deg));
end
if numel(lon2_deg) ~= numel(lon1_deg)
    lon2_deg = lon2_deg.*ones(size(lon1_deg));
    lon1_deg = lon1_deg.*ones(size(lon2_deg));
end

arrZero         = zeros(size(lon1_deg));
dist            = arrZero;
azimuth1_deg    = arrZero;
azimuth2_deg    = arrZero;
ctr_int         = arrZero;

for i = 1:numel(lat1_deg)
    delta_lat_deg = lat2_deg(i) - lat1_deg(i);
    delta_lon_deg = lon2_deg(i) - lon1_deg(i);
        
    if(delta_lat_deg == 0) && delta_lon_deg == 0
        dist(i) = 0;
        azimuth1_deg(i) = 0;
        azimuth2_deg(i) = 0;
    else
        
        %% Convert Input to Radians
        lat1 = lat1_deg(i) * D2R;       % [rad]
        lat2 = lat2_deg(i) * D2R;       % [rad]
        lon1 = lon1_deg(i) * D2R;       % [rad]
        lon2 = lon2_deg(i) * D2R;       % [rad]

        L = lon2 - lon1;                % [rad]
        U1 = atan((1-f)*tan(lat1));     % [rad]
        U2 = atan((1-f)*tan(lat2));     % [rad]
        sinU1 = sin(U1);
        cosU1 = cos(U1);
        sinU2 = sin(U2);
        cosU2 = cos(U2);

        % [Eq 13]
        lambda  = L;                    % [rad]
%         lambdap = 2*pi;                 % [rad]
        
        for ctr = 1:maxCtr
            sinLambda = sin(lambda);
            cosLambda = cos(lambda);

            % [Eq 14]
            sinSigma = sqrt( (cosU2*sinLambda)*(cosU2*sinLambda) + ...
                (cosU1*sinU2 - sinU1*cosU2*cosLambda) * (cosU1*sinU2 - sinU1*cosU2*cosLambda) );
            % [Eq 15]
            cosSigma = sinU1*sinU2 + cosU1*cosU2*cosLambda;
            % [Eq 16]
            sig = atan2( sinSigma, cosSigma );
            % [Eq 17]
            alpha = asin( cosU1*cosU2*sinLambda / sinSigma );
            cos2alpha = cos(alpha)*cos(alpha);
            % [Eq 18]
            cos2SigmaM = cosSigma - 2*sinU1*sinU2/cos2alpha;

            % [Eq 10]
            C = (f/16)*(cos2alpha)*(4 + f*(4-3*cos2alpha) );
            lambdap = lambda;
            % [Eq 11]
            lambda = L + (1-C)*f*sin(alpha)*( sig + ...
                C*sinSigma*( cos2SigmaM + C*cosSigma*(-1 + 2*cos2SigmaM*cos2SigmaM)));

            %% Determine Exit Criteria
            if( (~flgRunToMax) && (abs(lambda - lambdap) < (1e-12)) )
                break;
            end
        end
        ctr_int(i) = ctr;
        
%         if ctr == 1
%             disp('WARNING: Solution is Infinite.  Returning NULL.');
%             dist(i) = 0;
%             azimuth1_deg(i) = 0;
%             azimuth2_deg(i) = 0;
%             ctr_int(i) = ctr;
%             return;
%         end

        b = a*(1-f);
        uSq = cos2alpha*(a*a - b*b)/(b*b);
        % [Eq 3]
        AA = 1 + (uSq/16384)*( 4096 + uSq*(-768 + uSq*(320-175*uSq)));
        % [Eq 4]
        BB = (uSq/1024)*( 256 + uSq*(-128 + uSq*(74-47*uSq)));
        % [Eq 6]
        deltaSigma = BB*sinSigma*( cos2SigmaM + (BB/4)* ...
            ( cosSigma*(-1 + 2*cos2SigmaM * cos2SigmaM) ...
            - (BB/6)*cos2SigmaM*(-3 + 4*sinSigma*sinSigma)*(-3+4*cos2SigmaM * cos2SigmaM)));
        % [Eq 19]
        dist(i) = b*AA*(sig - deltaSigma);

%         if isnan(dist(i))
%             disp('Warning: Vincenty Distance Solution is NaN.');
%             disp('         Points # 1 & # 2 May Coincide');
%             disp('         Returning 0');
%             dist(i) = 0.0;
%         end

        sinLambda = sin(lambda);
        cosLambda = cos(lambda);
        
        %% Initial Bearing from Point 1 to Point 2 [deg]
        %  [Eq 20]
        azimuth1_deg(i) = atan2( (cosU2*sinLambda), (cosU1*sinU2 - sinU1*cosU2*cosLambda) ) * R2D;

        % Wrap Bearing to be between 0 and 360 deg
        azimuth1_deg(i) = mod(azimuth1_deg(i), 360);

        if isnan(azimuth1_deg(i))
            disp('Warning: Vincenty Azimuth Solution is NaN.');
            disp('         Points # 1 & # 2 May Coincide');
            disp('         Returning 0');
            azimuth1_deg(i) = 0.0;
        end

        %% Final Bearing from Point 1 to Point 2 [deg]
        %  [Eq 21]
        azimuth2_deg(i) = atan2( (cosU1*sinLambda), (-sinU1*cosU2 + cosU1*sinU2*cosLambda) ) * R2D;

        %    % Wrap Bearing to be between 0 and 360 deg
        azimuth2_deg(i) = mod(azimuth2_deg(i), 360);

        if isnan(azimuth2_deg(i))
            disp('Warning: Vincenty Azimuth2 Solution is NaN.');
            disp('         Points # 1 & # 2 May Coincide');
            disp('         Returning 0');
            azimuth2_deg(i) = 0.0;
        end
    end
end

end % << End of function vincenty >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110804 MWS: Added ability to specify the maximum number of iterations to
%             use and ability to use all the iterations, if desired.
% 101011 JPG: Added the capability to deal with matrices that had a zero.
% 100921 JPG: Filled in the function according to CoSMO standard.
% 100922 MWS: Function template created using CreateNewFunc
% 100719 PBH: Ported function over from the VSI Library
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/DISTANCE_CALCULATIONS/vincenty.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : James.Gray2@ngc.com   : g61720
% PBH: Patrick Healy        : patrick.healy@ngc.com : healypa
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi


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
