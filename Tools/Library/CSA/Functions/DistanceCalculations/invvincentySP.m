% INVVINCENTYSP Computes an origin point given a dest, dist, and azimuth (oblate)
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% invvincentySP:
%   Inverse Vincenty Special.  Computes Origin Point given a final 
%   Destination Point, Distance to Travel, and Initial Azimuth (Origin to 
%   Destination).  This function assumes an Oblate Spheroid as the Central 
%   Body.
% 
% SYNTAX:
%	[lat1, lon1, azimuth21] = invvincentySP(lat2, lon2, azimuth12, dist, a, f)
%	[lat1, lon1, azimuth21] = invvincentySP(lat2, lon2, azimuth12, dist)
%
% INPUTS: 
%	Name     	Size	Units		Description
%   lat2        [1x1]   [deg]       Geodetic Latitude of Dest. (Point # 2)
%   lon2        [1x1]   [deg]       Longitude of Destination (Point # 2)
%   azimuth12   [1x1]   [deg]       Initial Bearing from Origin (Point # 1)
%                                   towards Destination (Point # 2) 
%                                   (0 degrees is due North, positive 
%                                   rotation towards East)
%   dist        [1x1]   [length]    Distance to travel along Spheroid from
%                                   Origin to Destination
%   a           [1x1]   [length]    Central Body Semi-major Axis
%   f           [1x1]   [ND]        Central Body Flattening Parameter

%
% OUTPUTS: 
%	Name     	Size	Units       Description
%   lat1        [1x1]   [deg]       Geodetic Latitude of Origin (Point # 1)
%   lon1        [1x1]   [deg]       Longitude of Origin (Point # 1)
%   azimuth21   [1x1]   [deg]       Initial Bearing from Destination 
%                                   (Point # 2)towards Origin (Point # 1) 
%                                   (0 degrees is due North, positive 
%                                   rotation towards East)
%
% NOTES:
%   If the Central Body Semi-major axis 'a' and Flattening Parameter
%   'f' are not specified, METRIC WGS-84 Earth parameters are
%   assumed.
%
%   UNDERSTANDING THE FUNCTION
%   The (SP)ecial inverse vincenty function varies from its invvincenty 
%   origin in a few key ways.  It carries the invvincenty name,
%   however, because it utilizes the same core inverse vincenty equations.
%
%   In the invvincenty formula, users specify an ORIGIN point (Pt. 1), a
%   range to a DESTINATION (Pt. 2), and the azimuth of the destination with
%   respect to the origin (azimuth12).  The latitude and longitude of the
%   DESTINATION point are desired.  For completeness, the azimuth of the
%   origin with respect to the destination is also computed (azimuth21).
%
%   In the invvincentySP formula, users specify a DESTINATION point (Pt.
%   2), a range to an ORIGIN (Pt. 1), and the azimuth of the destination
%   with respect to the origin (azimuth12).  The latitude and longitude of
%   the ORIGIN point are desired.  For completeness, the azimuth of the
%   origin with respect to the destination is also computed (azimuth21).
%
%   Straight forward analytical solutions exist for solving the former
%   case.  These are found in invvincenty.m.  To solve the later,
%   calculations involving an iterative use of the vincenty formula are
%   utilized.  The function begins at the DESTINATION and, using azimuth12
%   as reference heading, projects possible solutions to the ORIGIN point.
%   Upon each calculation, the formula will then compute the heading from
%   the ORIGIN to the DESTINATION point and compare this value to the user
%   defined azimuth12.  The error of these two signals is fed back into the
%   equations and iterated on until the final "computed" azimuth12 varies
%   from the "commanded" azimuth12 by less than MATLAB's double precision
%   value, eps.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lat1, lon1, azimuth21] = invvincentySP(lat2, lon2, azimuth12, dist, a, f, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lat1, lon1, azimuth21] = invvincentySP(lat2, lon2, azimuth12, dist, a, f)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%    [1] http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
%    [2] http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.html
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit invvincentySP.m">invvincentySP.m</a>
%	  Driver script: <a href="matlab:edit Driver_invvincentySP.m">Driver_invvincentySP.m</a>
%	  Documentation: <a href="matlab:pptOpen('invvincentySP_Function_Documentation.pptx');">invvincentySP_Function_Documentation.pptx</a>
%
% See also vincenty, haversine, invhaversine, invvincenty
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/372
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

%   INTERNAL NOTES
%   Equations below are translated from Fortrann source code from [2].
%   Internally documented equations are those cross-checked with [1].

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/invvincentySP.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lat1, lon1, azimuth21] = invvincentySP(lat2, lon2, azimuth12, dist, a, f)

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
lat1= -1;
lon1= -1;
azimuth21= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        f= ''; a= ''; dist= ''; azimuth12= ''; lon2= ''; lat2= ''; 
%       case 1
%        f= ''; a= ''; dist= ''; azimuth12= ''; lon2= ''; 
%       case 2
%        f= ''; a= ''; dist= ''; azimuth12= ''; 
%       case 3
%        f= ''; a= ''; dist= ''; 
%       case 4
%        f= ''; a= ''; 
%       case 5
%        f= ''; 
%       case 6
%        
%       case 7
%        
%  end
%
%  if(isempty(f))
%		f = -1;
%  end
%% Main Function:
%% Conversions
R2D     = 180.0/acos(-1);   % Radians to Degrees
D2R     = acos(-1)/180.0;   % Degrees to Radians

%% Internal Constants
maxCtr = 100;       % [int]     Maximum Number of Iterations allowed
                    %           for convergence (soln)
maxIts = 100;       % [int]     Maximum Number of Iterations allowed
                    %           for azimuth12 convergence

if nargin == 4
    %% WGS-84 Earth Parameters
    a = 6378137.0;          % [m]   Semi-major Axis
    f = 1/298.257223563;    % [ND]  Flattening Factor
end

%% Set First Guess at azimuth
azimuth1 = azimuth12 + 180.0;

%% Convert Input to Radians
lat2 = lat2 * D2R;          % [rad]
lon2 = lon2 * D2R;          % [rad]
    
for i = 1:maxIts;
    FAZ  = azimuth1 * D2R;      % [rad]

    %% Translated [2] Fortrann Code
    %   Commented with Equation Lines from [1]
    tanU1   = (1-f) * tan(lat2);    % Reduced Latitude
    sinFAZ  = sin(FAZ);             % Sine of Forward Azimuth
    cosFAZ  = cos(FAZ);             % Cosine of Forward Azimuth

    % [Eq. 1]
    BAZ     = 0.0;
    if cosFAZ~= 0
        BAZ = 2*atan2(tanU1,cosFAZ);
    end

    cosU1   = 1/sqrt(tanU1*tanU1+1);
    sinU1   = tanU1*cosU1;
    % [Eq. 2]
    sinAlpha=cosU1*sinFAZ;

    cos2alpha     = -sinAlpha*sinAlpha+1;
    X = sqrt((1/(1-f)/(1-f) -1)*cos2alpha+1)+1;
    X=(X-2)/X;
    C = 1-X;
    C=(X*X/4 + 1)/C;
    D = (.375*X*X-1)*X;
    tanU1=dist/(1-f)/a/C;
    Sigma = tanU1;

    for ctr = 1:maxCtr
        sinSigma = sin(Sigma);
        cosSigma = cos(Sigma);
        cos2Sigmam = cos(BAZ+Sigma);

        % [Eq. 6]
        E = cos2Sigmam*cos2Sigmam*2 - 1;
        C = Sigma;
        X = E*cosSigma;
        % [Eq. 7]
        Sigma = E+E-1;
        Sigma=(((sinSigma*sinSigma*4-3)*Sigma*cos2Sigmam*D/6+X)*D/4-cos2Sigmam)*sinSigma*D+tanU1;

        if ( abs(Sigma-C) <= eps)
            break;
        end
    end
    if (ctr==maxCtr)
        disp('>> Warning: Max Iterations Observed in Inverse Vincenty');
        disp('             Solution May Not Be Accurate');
    end

    % [Eq. 8]
    num = sinU1*cosSigma+cosU1*sinSigma*cosFAZ;
    BAZ = -sinU1*sinSigma + cosU1*cosSigma*cosFAZ;
    den = (1-f)*sqrt(sinAlpha*sinAlpha+BAZ*BAZ);

    lat1 = atan2(num,den) * R2D;

    % [Eq. 9]
    X = atan2( (sinSigma*sinFAZ), (cosU1*cosSigma-sinU1*sinSigma*cosFAZ));

    % [Eq. 10]
    C = (f/16)*cos2alpha*(4 + f*(4-3*cos2alpha));

    % [Eq. 11]
    D=((E*cosSigma*C+cos2Sigmam)*sinSigma*C+Sigma)*sinAlpha;
    lon1 = (lon2 + X-(1-C)*D*f) * R2D;

    %% Wrap Longitude to be within +/- 180
    lon1 = mod(lon1, 360.0);
    if lon1 > 180.0
        lon1 = lon1 - 360.0;
    end

%     % [Eq. 12]
    azimuth2 = atan2(sinAlpha,BAZ)*R2D ;
    azimuth2 = mod(azimuth2, 360.0)-180.0;
    
    %% Compute Error between Desired and Current
    angError = azimuth12 - azimuth2;
%     if abs(angError) <= 1e-10;
    if abs(angError) <= eps;
        break;
    else
        azimuth1 = azimuth1 + angError;
    end
end

azimuth21 = azimuth1;

%% Compile Outputs:
%	lat1= -1;
%	lon1= -1;
%	azimuth21= -1;

end % << End of function invvincentySP >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
