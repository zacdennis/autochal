% INVVINCENTY computes a final point given a distance, azimuth, and origin (oblate)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% invvincenty:
%   Computes a destination point given a distance and azimuth from a
%   Geodectic Latitude/Longitude point.  Users will define an initial point
%   with a specific latitude and longitude.  They will also provide a range
%   and an azimuth to some point, (Point 2).  This function will iterate 
%   until it achieves a desired accuracy, and the function assumes an 
%   oblate spheroid as the central body.
% SYNTAX:
%	[lat2, lon2, azimuth2] = invvincenty(lat1, lon1, azimuth1, dist, a, f)
%	[lat2, lon2, azimuth2] = invvincenty(lat1, lon1, azimuth1, dist)
%
% INPUTS: 
%	Name		Size		Units		Description
%   lat1        [Variable]  [deg]       Geodetic Latitude of Origin (Point 
%                                       #1)
%   lon1        [Variable]  [deg]       Longitude of Origin (Point #1)
%   azimuth1    [Variable]  [deg]       Initial Bearing from Point #1 
%                                       towards Point #2, (0 degrees is due 
%                                       North, positive rotation towards
%                                       East)
%   dist        [Variable]  [length]    Distance to travel along Spheroid 
%                                       from Origin to Destination
%   a           [1x1]       [length]    Central Body Semi-major Axis
%   f           [1x1]       [ND]        Central Body Flattening Parameter                                       
%                                       Default Values:
%                                       a = 6378137.0; % [m]Semi-major Axis
%                                       f = 1/298.257223563; 
%                                                  % [ND] Flattening Factor 
% OUTPUTS: 
%	Name		Size		Units		Description
%   lat2        [Variable]  [deg]       Geodetic Latitude of Destination
%                                       (Point #2)
%   lon2        [Variable]  [deg]       Longitude of Destination (Point #2)
%   azimuth2    [Variable]  [deg]       Initial Bearing from Point #1 
%                                       towards Point #2, (0 degrees is due                                       
%                                       North, positive rotation towards
%                                       East)
% NOTES:
%   This calculation is not unit specific.  Input distances only need to be
%   of the same unit.  Standard METRIC [m] or ENGLISH [ft] distance
%   should be used. 
%   Inputs should have the same dimensions, which can be scalar
%	([1]), a vector ([1xN] or [Nx1]), or a multi-dimensional matrix 
%   (M x N x P x ...]).  The outputs Lat and Lon will carry the same
%   dimensions as the inputs.
%   If the Central Body Semi-major axis 'a' and Flattening Parameter
%   'f' are not specified, METRIC WGS-84 Earth parameters are assumed.
%
% EXAMPLES:
%   Example 1:
%   A simple case, running invvincenty with all scalar arguments heading
%   due north.
%
%   lat1 = 10;              %[deg]
%   lon1 = 20;              %[deg]
%   azimuth1 = 0;           %[deg]
%   dist = 2000;            %[km]
%   a = 6371;               %[km]
%   f = 1/298.257;          %[ND]
%   [lat2, lon2, azimuth2] = invvincenty(lat1, lon1, azimuth1, dist, a, f);
%   Returns:
%   lat2:     28.087  [deg]
%   lon2:     20.000  [deg]
%   azimuth2:  0.000  [deg]
%
%   Example 2:
%   Running invvincenty with multiple bearings.  The origin is Paris,
%   France, and this shows various endpoints when traveling the same 
%   distance, but with different initial bearings.
%
%   lat1 = 48.9;                        %[deg]
%   lon1 = 2.33;                        %[deg]
%   azimuth1 = [-15 -45 -90 -180 0];    %[deg]
%   dist = 9e5;                         %[m]
%   [lat2, lon2, azimuth2] = invvincenty(lat1, lon1, azimuth1, dist);
%   Returns:
%   lat2:        56.658     54.241     48.252     40.801     56.987 [deg]
%   lon2:        -1.458     -7.446     -9.841      2.330      2.330 [deg]
%   azimuth2:   341.976    307.326    260.859    180.000      0.000 [deg]
%
% SOURCE DOCUMENTATION:
%	[1]    http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
%	[2]    http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.ht
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit invvincenty.m">invvincenty.m</a>
%	  Driver script: <a href="matlab:edit Driver_invvincenty.m">Driver_invvincenty.m</a>
%	  Documentation: <a href="matlab:pptOpen('invvincenty_Function_Documentation.pptx');">invvincenty_Function_Documentation.pptx</a>
%
% See also VINCENTY, HAVERSINE, INVHAVERSINE
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/371
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

%   INTERNAL NOTES
%   Equations below are translated from Fortrann source code from [2].
%   Internally documented equations are those cross-checked with [1].

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/invvincenty.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lat2, lon2, azimuth2] = invvincenty(lat1, lon1, azimuth1, dist, a, f)

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
azimuth2= -1;

%% Input Argument Conditioning:
if nargin < 4
   disp([mfnam ' :: Please refer to useage of invvincenty' endl ...
       'Syntax: [lat2, lon2, azimuth2] = invvincenty(lat1, lon1, '...
       'azimuth1, dist, a, f)']);
   return;
end;

if nargin == 4
    %% WGS-84 Earth Parameters
    a = 6378137.0;          % [m]   Semi-major Axis
    f = 1/298.257223563;    % [ND]  Flattening Factor
end

if (isempty(lat1) || isempty(lon1) || isempty(azimuth1) || isempty(dist)...
        || isempty(a) || isempty(f))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(lat1) || ischar(lon1) || ischar(azimuth1) || ischar(dist) || ...
        ischar(a) || isempty(f))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if (numel(a) ~= 1) || numel(f) ~= 1
    errstr = [mfnam tab 'ERROR: Ellipsoid parameters are not of dimension [1]'];
    error([mfnam 'Error:invvincenty:dimension'], errstr);
end

[lat1 lon1] = CheckLatLon(lat1, lon1);

%% Conversions
R2D     = 180.0/acos(-1);   % Radians to Degrees
D2R     = acos(-1)/180.0;   % Degrees to Radians

%% Internal Constants
maxCtr = 100;    % [int]     Maximum Number of Iterations allowed
                 %           for convergence

%% Convert Input to Radians
lat1 = lat1 .* D2R;          % [rad]
lon1 = lon1 .* D2R;          % [rad]
FAZ  = azimuth1 .* D2R;      % [rad]

%% Main Function:
%% Translated [2] Fortrann Code
%   Commented with Equation Lines from [1]
tanU1   = (1-f) .* tan(lat1);   % Reduced Latitude
sinFAZ  = sin(FAZ);             % Sine of Forward Azimuth
cosFAZ  = cos(FAZ);             % Cosine of Forward Azimuth

% [Eq. 1]
BAZ     = 0.0;
if cosFAZ ~= 0
    BAZ = 2.*atan2(tanU1,cosFAZ);
end

cosU1   = 1./sqrt(tanU1.*tanU1+1);
sinU1   = tanU1.*cosU1;
% [Eq. 2]
sinAlpha=cosU1.*sinFAZ;

cos2alpha     = -sinAlpha .* sinAlpha+1;
X = sqrt((1./(1-f)./(1-f) -1).*cos2alpha+1)+1;
X=(X-2)./X;
C = 1-X;
C=(X.*X/4 + 1)./C;
D = (.375.*X.*X-1).*X;
tanU1=dist./(1-f)./a./C;
Sigma = tanU1;

for ctr = 1:maxCtr
    sinSigma = sin(Sigma);
    cosSigma = cos(Sigma);
    cos2Sigmam = cos(BAZ+Sigma);

    % [Eq. 6]
    E = cos2Sigmam.*cos2Sigmam.*2 - 1;
    C = Sigma;
    X = E.*cosSigma;
    % [Eq. 7]
    Sigma = E+E-1;
    Sigma=(((sinSigma.*sinSigma.*4-3).*Sigma.*cos2Sigmam.*D./6+X) ...
        .*D./4-cos2Sigmam).*sinSigma.*D+tanU1;
    
    if ( abs(Sigma-C) <= eps)
        break;
    end
end
if (ctr==maxCtr)
    disp('>> Warning: Max Iterations Observed in Inverse Vincenty');
    disp('             Solution May Not Be Accurate');
end

% [Eq. 8]
num = sinU1.*cosSigma+cosU1.*sinSigma.*cosFAZ;
BAZ = sinU1.*sinSigma - cosU1.*cosSigma.*cosFAZ;
den = (1-f).*sqrt(sinAlpha.*sinAlpha+BAZ.*BAZ);

lat2 = atan2(num,den) .* R2D;

% [Eq. 9]
X = atan2( (sinSigma.*sinFAZ), (cosU1.*cosSigma-sinU1.*sinSigma.*cosFAZ));

% [Eq. 10]
C = (f/16).*cos2alpha.*(4 + f.*(4-3.*cos2alpha));

% [Eq. 11]
D=((E.*cosSigma.*C+cos2Sigmam).*sinSigma.*C+Sigma).*sinAlpha;
lon2 = (lon1 + X-(1-C).*D.*f) .* R2D;

%% Wrap Longitude to be within +/- 180
[lat2 lon2] = CheckLatLon(lat2, lon2);

%% Final Bearing from Point 1 to Point 2 [deg]
% % [Eq. 12]
azimuth2 = atan2(sinAlpha,-BAZ).*R2D;

% Wrap azimuth to be between 0 and 360 deg.
azimuth2 = mod(azimuth2, 360.0);

end % << End of function invvincenty >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101005 JPG: Changed the output of azimuth2 to be final bearing.
% 101004 JPG: Modified the algorithm for error checking, and the ability to
% take in vector/matrix inputs.
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
