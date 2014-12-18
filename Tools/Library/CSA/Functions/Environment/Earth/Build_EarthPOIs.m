% BUILD_EARTHPOIS Builds the Points of Interest Earth File
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Build_EarthPOIs:
%   Builds the point of interest structure for Earth.  Requires the use of
%   the 'Mapping Toolbox'.  Function will build the 'lstPOI' output
%   structure and save it as 'EarthPOIs.mat' in same directory as this
%   file.
%
%   This is a support function for 'GetPOIInfo'
% 
% SYNTAX:
%	lstPOI = Build_EarthPOIs(flgOKtoSave)
%
% INPUTS: 
%	Name            Size		Units		Description
%   flgOKtoSave     [1]         [bool]      Ok to resave data if 'Mapping
%                                            Toolbox' license is not
%                                            available?  (Default false)
% OUTPUTS: 
%	Name            Size		Units		Description
%	lstPOI          {1xN struct}            Points of Interest Structure
%    .Name          'string'    [char]      Point of Interest
%    .Source        'string'    [char]      Reference source
%    .Latitude_deg  [1]         [deg]       Geodetic Latitude
%    .Longitude_deg [1]         [deg]       Longitude
%    .Elevation_ft  [1]         [ft]        Field elevation
%    .PsiMag_deg    [1]         [deg]       Magnetic heading (if applicable)
%    .PsiTrue_deg   [1]         [deg]       True heading (if applicable)
%
% NOTES:
%
% EXAMPLES:
%	% Build the 'EarthPOIs.mat' file
%	lstPOI = Build_EarthPOIs();
%
%   lstPOI(1)
%   % returns...
%   %              Name: 'El Segundo'
%   %            Source: 'LN251 in El Segundo 202 PSIL'
%   %      Latitude_deg: 33.9290
%   %     Longitude_deg: -118.3800
%   %      Elevation_ft: 18
%   %        PsiMag_deg: 0
%   %       PsiTrue_deg: 0
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Build_EarthPOIs.m">Build_EarthPOIs.m</a>
%
% See also GetPOIInfo 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/755
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function lstPOI = Build_EarthPOIs(flgOKtoSave)

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

if((nargin == 0) || isempty(flgOKtoSave))
    flgOKtoSave = 1;
end

%% Main Function:
i = 0; lstPOI = {};

i = i + 1;
lstPOI(i).Name = 'El Segundo';
lstPOI(i).Source         = 'LN251 in El Segundo 202 PSIL';
lstPOI(i).Latitude_deg   = 33.929;
lstPOI(i).Longitude_deg  = -118.38;
lstPOI(i).Elevation_ft   = 18;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LAX';    % Los Angeles
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLAX';
lstPOI(i).Latitude_deg   =  33.9424955;
lstPOI(i).Longitude_deg  = -118.4080684;
lstPOI(i).Elevation_ft   = 125;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LGB';    % Long Beach
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLGB';
lstPOI(i).Latitude_deg   = 33.8177540;
lstPOI(i).Longitude_deg  = -118.1517330;
lstPOI(i).Elevation_ft   = 60;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'AVX';    % Catalina
lstPOI(i).Source         = 'http://www.airnav.com/airport/KAVX';
lstPOI(i).Latitude_deg   =  33.4049972;
lstPOI(i).Longitude_deg  = -118.4157694;
lstPOI(i).Elevation_ft   = 1602;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SNA';    % John Wayne
lstPOI(i).Source         = 'http://www.airnav.com/airport/KSNA';
lstPOI(i).Latitude_deg   =  33.6756667;
lstPOI(i).Longitude_deg  = -117.8682222;
lstPOI(i).Elevation_ft   = 56;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'ONT';    % Ontario
lstPOI(i).Source         = 'http://www.airnav.com/airport/KONT';
lstPOI(i).Latitude_deg   =  34.0560000;
lstPOI(i).Longitude_deg  = -117.6011944;
lstPOI(i).Elevation_ft   = 944;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'HHR';    % Hawthorne
lstPOI(i).Source         = 'http://www.airnav.com/airport/KHHR';
lstPOI(i).Latitude_deg   =  33.9228397;
lstPOI(i).Longitude_deg  = -118.3351872;
lstPOI(i).Elevation_ft   = 66;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'TOA';    % Torrance
lstPOI(i).Source         = 'http://www.airnav.com/airport/KTOA';
lstPOI(i).Latitude_deg   =  33.8033889;
lstPOI(i).Longitude_deg  = -118.3396111;
lstPOI(i).Elevation_ft   = 103;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SMO';    % Santa Monica
lstPOI(i).Source         = 'http://www.airnav.com/airport/KSMO';
lstPOI(i).Latitude_deg   =  34.0158333;
lstPOI(i).Longitude_deg  = -118.4513056;
lstPOI(i).Elevation_ft   = 177;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'VNY';    % Van Nuys
lstPOI(i).Source         = 'http://www.airnav.com/airport/KVNY';
lstPOI(i).Latitude_deg   =  34.2098056;
lstPOI(i).Longitude_deg  = -118.4899722;
lstPOI(i).Elevation_ft   = 802;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'EDW';    % Edwards AFB
lstPOI(i).Source         = 'http://www.airnav.com/airport/KEDW';
lstPOI(i).Latitude_deg   =  34.9080884;
lstPOI(i).Longitude_deg  = -117.8855285;
lstPOI(i).Elevation_ft   = 2311;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'NKX';    % Miramar Marine Corps
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNKX';
lstPOI(i).Latitude_deg   =  32.8683456;
lstPOI(i).Longitude_deg  = -117.1417347;
lstPOI(i).Elevation_ft   = 477;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'PMD';    % Palmdale
lstPOI(i).Source         = 'http://www.airnav.com/airport/KPMD';
lstPOI(i).Latitude_deg   =  34.6293889;
lstPOI(i).Longitude_deg  = -118.0845528;
lstPOI(i).Elevation_ft   = 2543;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'MHV';    % Mohave
lstPOI(i).Source         = 'http://www.airnav.com/airport/KMHV';
lstPOI(i).Latitude_deg   =  35.0586389;
lstPOI(i).Longitude_deg  = -118.1505556;
lstPOI(i).Elevation_ft   = 2801;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'NID';    % China Lake
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNID';
lstPOI(i).Latitude_deg   =  35.6855000;
lstPOI(i).Longitude_deg  = -117.6920000;
lstPOI(i).Elevation_ft   = 2283;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SAN';    % San Diego International
lstPOI(i).Source         = 'http://www.airnav.com/airport/KSAN';
lstPOI(i).Latitude_deg   =  32.7335556;
lstPOI(i).Longitude_deg  = -117.1896667;
lstPOI(i).Elevation_ft   = 17;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'VBG';    % Vandenberg AFB
lstPOI(i).Source         = 'http://www.airnav.com/airport/KVBG';
lstPOI(i).Latitude_deg   =  34.7373361;
lstPOI(i).Longitude_deg  = -120.5843083;
lstPOI(i).Elevation_ft   = 369;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SBA';    % Santa Barbara
lstPOI(i).Source         = 'http://www.airnav.com/airport/KSBA';
lstPOI(i).Latitude_deg   =  34.4261944;
lstPOI(i).Longitude_deg  = -119.8415000;
lstPOI(i).Elevation_ft   = 13;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'OXR';    % Oxnard
lstPOI(i).Source         = 'http://www.airnav.com/airport/KOXR';
lstPOI(i).Latitude_deg   =  34.2008056;
lstPOI(i).Longitude_deg  = -119.2072222;
lstPOI(i).Elevation_ft   = 45;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'EWR';    % Newark
lstPOI(i).Source         = 'http://www.airnav.com/airport/KEWR';
lstPOI(i).Latitude_deg   =  40.6925000;
lstPOI(i).Longitude_deg  = -74.1686667;
lstPOI(i).Elevation_ft   = 18;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'ACY';    % Atlantic City
lstPOI(i).Source         = 'http://www.airnav.com/airport/KACY';
lstPOI(i).Latitude_deg   =  39.4575833;
lstPOI(i).Longitude_deg  = -74.5771667;
lstPOI(i).Elevation_ft   = 75;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'JFK';    % John F Kennedy - NYC
lstPOI(i).Source         = 'http://www.airnav.com/airport/KJFK';
lstPOI(i).Latitude_deg   =  40.6397511;
lstPOI(i).Longitude_deg  =  -73.7789256;
lstPOI(i).Elevation_ft   = 14;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LGA';    % La Guardia - NYC
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLGA';
lstPOI(i).Latitude_deg   =  40.7772500;
lstPOI(i).Longitude_deg  =  -73.8726111;
lstPOI(i).Elevation_ft   = 14;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'Lakehurst Jump Circle';
lstPOI(i).Source         = 'http://www.mapquest.com/ Intersection of Jump Circle roads';
lstPOI(i).Latitude_deg   = 40.036687;
lstPOI(i).Longitude_deg  = -74.370943;
lstPOI(i).Elevation_ft   = 100;  % TBD - guestimate
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'Lakehurst Mat 3';
lstPOI(i).Source         = 'http://www.mapquest.com/ 2nd tie-down in front of hangar 6';
lstPOI(i).Latitude_deg   = 40.028174;
lstPOI(i).Longitude_deg  = -74.338233;
lstPOI(i).Elevation_ft   = 100;  % TBD - guestimate
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'Lakehurst RW 6';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNEL';
lstPOI(i).Latitude_deg   = dms2dec([40 1.891 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-74 21.3945 0], 'lon');
lstPOI(i).Elevation_ft   = 88;
lstPOI(i).PsiMag_deg     = 62;
lstPOI(i).PsiTrue_deg    = 51;

i = i + 1;
lstPOI(i).Name = 'Lakehurst RW 24';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNEL';
lstPOI(i).Latitude_deg   = dms2dec([40 2.414833 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-74 20.56733 0], 'lon');
lstPOI(i).Elevation_ft   = 100.5;
lstPOI(i).PsiMag_deg     = 242;
lstPOI(i).PsiTrue_deg    = 231;

i = i + 1;
lstPOI(i).Name = 'Lakehurst RW 15';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNEL';
lstPOI(i).Latitude_deg   = dms2dec([40 2.377333 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-74 21.617167 0], 'lon');
lstPOI(i).Elevation_ft   = 96.9;
lstPOI(i).PsiMag_deg     = 152;
lstPOI(i).PsiTrue_deg    = 141;

i = i + 1;
lstPOI(i).Name = 'Lakehurst RW 33';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KNEL';
lstPOI(i).Latitude_deg   = dms2dec([40 1.741667 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-74 20.935667 0], 'lon');
lstPOI(i).Elevation_ft   = 87.8;
lstPOI(i).PsiMag_deg     = 332;
lstPOI(i).PsiTrue_deg    = 321;

i = i + 1;
lstPOI(i).Name = 'Melbourne';
lstPOI(i).Source         = 'Doug Dyer & Skye Otten';
lstPOI(i).Latitude_deg   = 28.097301;
lstPOI(i).Longitude_deg  = -80.646247;
lstPOI(i).Elevation_ft   = 25.2;
lstPOI(i).PsiMag_deg     = 45;
lstPOI(i).PsiTrue_deg    = 42;

i = i + 1;
lstPOI(i).Name = 'Melbourne RW 5';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KMLB';
lstPOI(i).Latitude_deg   = dms2dec([28 5.7542 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-80 38.243533 0], 'lon');
lstPOI(i).Elevation_ft   = 25.2;
lstPOI(i).PsiMag_deg     = 45;
lstPOI(i).PsiTrue_deg    = 42;

i = i + 1;
lstPOI(i).Name = 'Melbourne RW 23';
lstPOI(i).Source         = 'http://www.airnav.com/airport/KMLB';
lstPOI(i).Latitude_deg   = dms2dec([28 6.121667 0], 'lat');
lstPOI(i).Longitude_deg  = dms2dec([-80 37.869017 0], 'lon');
lstPOI(i).Elevation_ft   = 21.4;
lstPOI(i).PsiMag_deg     = 225;
lstPOI(i).PsiTrue_deg    = 222;

i = i + 1;
lstPOI(i).Name = 'Kandahar';
lstPOI(i).Source         = 'TBD';
lstPOI(i).Latitude_deg   = 31.50583;
lstPOI(i).Longitude_deg  = 65.84778;
lstPOI(i).Elevation_ft   = 1000;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LAS';    % Las Vegas - McCarran
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLAS';
lstPOI(i).Latitude_deg   =  36.0800556;
lstPOI(i).Longitude_deg  =  -115.15225;
lstPOI(i).Elevation_ft   = 2181;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LSV';    % Las Vegas - Nellis AFB
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLSV';
lstPOI(i).Latitude_deg   =  36.2361972;
lstPOI(i).Longitude_deg  =  -115.0342528;
lstPOI(i).Elevation_ft   = 1870;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'RNO';    % Reno
lstPOI(i).Source         = 'http://www.airnav.com/airport/KRNO';
lstPOI(i).Latitude_deg   =  39.4991111;
lstPOI(i).Longitude_deg  =  -119.7681111;
lstPOI(i).Elevation_ft   = 4415;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'AFF';    % USAF Academy Airfield
lstPOI(i).Source         = 'http://www.airnav.com/airport/KAFF';
lstPOI(i).Latitude_deg   =  38.9697150;
lstPOI(i).Longitude_deg  =  -104.8128308;
lstPOI(i).Elevation_ft   = 6572;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'DEN';    % Denver Intl
lstPOI(i).Source         = 'http://www.airnav.com/airport/KDEN';
lstPOI(i).Latitude_deg   =  39.8616667;
lstPOI(i).Longitude_deg  =  -104.6731667;
lstPOI(i).Elevation_ft   = 5433.8;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'BOI';    % Boise Air Terminal / Gowen
lstPOI(i).Source         = 'http://www.airnav.com/airport/KBOI';
lstPOI(i).Latitude_deg   =  43.5643611;
lstPOI(i).Longitude_deg  =  -116.2228611;
lstPOI(i).Elevation_ft   = 2871;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'HLN';    % Helena Regional Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KHLN';
lstPOI(i).Latitude_deg   =  46.6068056;
lstPOI(i).Longitude_deg  =  -111.9827500;
lstPOI(i).Elevation_ft   = 3877;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'GTF';    % Great Falls International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KGTF';
lstPOI(i).Latitude_deg   =  47.4826539;
lstPOI(i).Longitude_deg  =  -111.3706100;
lstPOI(i).Elevation_ft   = 3680;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'BZN';    % Bozeman Yellowstone International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KBZN';
lstPOI(i).Latitude_deg   =  45.7775717;
lstPOI(i).Longitude_deg  =   -111.1520216;
lstPOI(i).Elevation_ft   = 4473;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'GEG';    % Spokane International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KGEG';
lstPOI(i).Latitude_deg   =  47.6190278;
lstPOI(i).Longitude_deg  =  -117.5352222;
lstPOI(i).Elevation_ft   = 2385;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'PDX';    % Portland International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KPDX';
lstPOI(i).Latitude_deg   =  45.5887089;
lstPOI(i).Longitude_deg  =  -122.5968694;
lstPOI(i).Elevation_ft   = 31;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'FAT';    % Fresno International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KFAT';
lstPOI(i).Latitude_deg   =  36.7764156;
lstPOI(i).Longitude_deg  =  -119.7186466;
lstPOI(i).Elevation_ft   = 336;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'BFL';    % Meadows Field Airport - Bakersfield, CA
lstPOI(i).Source         = 'http://www.airnav.com/airport/KBFL';
lstPOI(i).Latitude_deg   =  35.4338611;
lstPOI(i).Longitude_deg  =  -119.0576667;
lstPOI(i).Elevation_ft   = 510;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'PHX';    % Phoenix Sky Haror International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KPHX';
lstPOI(i).Latitude_deg   =  33.4342778;
lstPOI(i).Longitude_deg  =   -112.0115833;
lstPOI(i).Elevation_ft   = 1135;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'TUS';    % Tuscon International Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KTUS';
lstPOI(i).Latitude_deg   =  32.1160833;
lstPOI(i).Longitude_deg  =    -110.9410278;
lstPOI(i).Elevation_ft   = 2643.1;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'E25';    % Wickenburg Municipal Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/E25';
lstPOI(i).Latitude_deg   =  33.9706293;
lstPOI(i).Longitude_deg  =  -112.7950898;
lstPOI(i).Elevation_ft   = 2378.6;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'DVT';    % Deer Valley Municipal Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KDVT';
lstPOI(i).Latitude_deg   =  33.6883056;
lstPOI(i).Longitude_deg  =  -112.0825556;
lstPOI(i).Elevation_ft   = 1478.1;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SDL';    % Scottsdale Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KSDL';
lstPOI(i).Latitude_deg   =  33.6228889;
lstPOI(i).Longitude_deg  =  -111.9105278;
lstPOI(i).Elevation_ft   = 1510;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'SDL';    % Glendale Municipal Airport
lstPOI(i).Source         = 'http://www.airnav.com/airport/KGEU';
lstPOI(i).Latitude_deg   =  33.5269167;
lstPOI(i).Longitude_deg  =   -112.2951389;
lstPOI(i).Elevation_ft   = 1071;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

i = i + 1;
lstPOI(i).Name = 'LUF';    % Luke Air Force Base (Glendale, AZ)
lstPOI(i).Source         = 'http://www.airnav.com/airport/KLUF';
lstPOI(i).Latitude_deg   =  33.5349669;
lstPOI(i).Longitude_deg  =   -112.3831996;
lstPOI(i).Elevation_ft   = 1085;
lstPOI(i).PsiMag_deg     = 0;
lstPOI(i).PsiTrue_deg    = 0;

%% Add in other cities from MATLAB's databases
flgGotLicense = license('test', 'map_toolbox');
if(flgGotLicense)
    cities = shaperead('worldcities', 'UseGeoCoords', true);
    for iCity = 1:numel(cities);
        i = i + 1;
        lstPOI(i).Name          = cities(iCity).Name;
        lstPOI(i).Source        = sprintf('MATLAB: cities = shaperead(''worldcities'', ''UseGeoCoords'', true); cities(%d)', iCity);
        lstPOI(i).Latitude_deg  = cities(iCity).Lat;
        lstPOI(i).Longitude_deg = cities(iCity).Lon;
        lstPOI(i).Elevation_ft  = 0;
        lstPOI(i).PsiMag_deg    = 0;
        lstPOI(i).PsiTrue_deg   = 0;
    end
    flgOKtoSave = 1;
 
else
    if(~flgOKtoSave)
        mlink = ['<a href = "matlab:' mfnam '(1)">' mfnam '(1)</a>']; % Hyperlink to mask help that can be added to a error disp
        disp(sprintf('%s : WARNING : No license for ''Map Toolbox''.  Unable to fully build Points of Interest table.', mfnam));
        disp(sprintf('%s             Ignoring call to save new ''lstPOI'' table.', mfspc, mlink));
        disp(sprintf('%s             If you''d like to save data without the Map Toolbox data, rerun function %s', mfspc, mlink));
    end
end

if(flgOKtoSave)
    SaveDir = fileparts(mfilename('fullpath'));
    save([SaveDir filesep 'EarthPOIs.mat'], 'lstPOI');
end

end % << End of function Build_EarthPOIs >>

%% REVISION HISTORY
% YYMMDD INI: note
% 121108 MWS: Created function using CreateNewFunc
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
