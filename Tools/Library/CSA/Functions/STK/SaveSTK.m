% SAVESTK Saves Ephemeris and Attitude Data for STK Playback
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SaveSTK:
%     Saves Ephemeris and Attitude Data for STK Playback
%   This function takes the parsed StateBus and generates the needed 
%   Ephemeris (.e) and Attitude (.a) files readable by STK.  Note that the
%   Ephemeris files will contain METRIC (eg. meters) units regardless of
%   inputted StateBus.
% 
% SYNTAX:
%	[] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt, varargin, 'PropertyName', PropertyValue)
%	[] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt, varargin)
%	[] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt)
%
% INPUTS: 
%	Name          	Size		Units		Description
%   StateBus    {struct}    Parsed StateBus
%       .simtime        [M x 1]     [sec]       Simulation Time
%       .GeodeticLat    [M x 1]     [deg]       Geodetic Latitude
%       .Longitude      [M x 1]     [deg]       Longitude
%       .Alt            [M x 1]     [ft or m]   Altitude
%       .LatDot         [M x 1]     [deg/s]     Latitude Rate
%       .LonDot         [M x 1]     [deg/s]     Longitude Rate
%       .AltDot         [M x 1]     [ft/s or m/s]   Altitude Rate
%       .Quaternions    [M x 4]     [ND]    Quaternion Orientation
%
%   strStateBus         [string]    StateBus identifier string (Emphemeris
%                                   and Attitude files will be named 
%                                   strStateBus.a and strStateBus.e
%   EpochStrSTK         [string]    Starting Epoch of Simulation of form
%                                   DAY MONTH YEAR TIME (eg. 1 Jan 2006
%                                   12:30:30.000)
%
%   flgEnglishUsed      [bool]      {1/0: true/false} StateBus enterred
%                                    contains ENGLISH units (default: 0 
%                                    [false])
%
%   txt         {struct}    STK Setup Parameters
%       .STK_version    [string]    STK Version (default: 'stk.v.6.1')
%       .InterpMethod   [string]    Interpoliation Method
%                                    (default: 'Lagrange')
%       .InterpSamples  [int]       Samples used for Interpolation
%                                    (default: 5)
%       .CentralBody    [string]    Central Body Identifier
%                                    (default: 'Earth')
%       .CoordSystem    [string]    Central Body Coordinate Frame
%                                    (default: 'Fixed')
%       .CoordAxes      [string]    Central Body Coordiante Axis
%                                    (default: 'J2000')
%       .BlockingFactor [int]       Blocking Factor (default: 20)
%       .InterpOrder    [int]       Interpolation Order (default: 1)
%       .Units          [string]    Units of Ephemeris Data (default:
%                                    Meters (for METRIC) )
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name          	Size		Units		Description
%	    	              <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
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
%	Source function: <a href="matlab:edit SaveSTK.m">SaveSTK.m</a>
%	  Driver script: <a href="matlab:edit Driver_SaveSTK.m">Driver_SaveSTK.m</a>
%	  Documentation: <a href="matlab:pptOpen('SaveSTK_Function_Documentation.pptx');">SaveSTK_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/554
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/STK/SaveSTK.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = SaveSTK(StateBus, strStateBus, EpochStrSTK, flgEnglishUsed, txt, varargin)

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


%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        txt= ''; flgEnglishUsed= ''; EpochStrSTK= ''; strStateBus= ''; StateBus= ''; 
%       case 1
%        txt= ''; flgEnglishUsed= ''; EpochStrSTK= ''; strStateBus= ''; 
%       case 2
%        txt= ''; flgEnglishUsed= ''; EpochStrSTK= ''; 
%       case 3
%        txt= ''; flgEnglishUsed= ''; 
%       case 4
%        txt= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(txt))
%		txt = -1;
%  end
%% Main Function:
warning off MATLAB:DELETE:FileNotFound;

if nargin < 5
    txt = [];
end

%% Use Default Values for STK Setup:
if(~isfield(txt, 'STK_verison'))
    txt.STK_version = 'stk.v.6.1';
end

if(~isfield(txt, 'InterpMethod'))
    txt.InterpMethod = 'Lagrange';
end

if(~isfield(txt, 'InertpSamples'))
    txt.InterpSamples = 5;
end

if(~isfield(txt, 'CentralBody'))
    txt.CentralBody = 'Earth';
end

if(~isfield(txt, 'CoordSystem'))
    txt.CoordSystem = 'Fixed';
end

if(~isfield(txt, 'CoordAxes'))
    txt.CoordAxes = 'J2000';
end

if(~isfield(txt, 'BlockingFactor'))
    txt.BlockingFactor = 20;
end

if(~isfield(txt, 'InterpOrder'))
    txt.InterpOrder = 1;
end

if(~isfield(txt, 'Units'))
    txt.Units       = 'Meters';
end

if nargin < 4
    flgEnglishUsed = 0;
end    

%% Conversion
if flgEnglishUsed == 1
    %% Convert English to Metric Units:
    UnitConversion = 0.3058;     % Feet to Meters
else
    %% Metric Units Inputted:
    UnitConversion = 1;
end

%% Parse StateBus:
NumPoints       = length(StateBus.simtime);
vecClock        = StateBus.simtime;
vecLat          = StateBus.GeodeticLat;
vecLon          = StateBus.Longitude;
vecAlt          = StateBus.Alt * UnitConversion;
vecLatD         = StateBus.GeodeticLatDot;
vecLonD         = StateBus.LongitudeDot;
vecAltD         = StateBus.AltDot * UnitConversion;
vecQ1           = StateBus.Quaternion(:,1);
vecQ2           = StateBus.Quaternion(:,2);
vecQ3           = StateBus.Quaternion(:,3);
vecQ4           = StateBus.Quaternion(:,4);

%% Build Ephemeric and Attitude Filenames:
EphemerisFilename   = [strStateBus '.e'];
AttitudeFilename    = [strStateBus '.a'];

%% ========================================================================
%                           CREATE EPHEMERIS FILE
%% ========================================================================

delete(EphemerisFilename);
eid = fopen(EphemerisFilename, 'w');

%% Create Header Information:
fprintf(eid, '%s\n\n', txt.STK_version);
fprintf(eid, 'BEGIN Ephemeris\n\n');
fprintf(eid, 'NumberOfEphemerisPoints %.0f\n', NumPoints);
fprintf(eid, 'ScenarioEpoch           %s\n', EpochStrSTK);
fprintf(eid, 'InterpolationMethod     %s\n', txt.InterpMethod);
fprintf(eid, 'InterpolationSamplesM1      %d\n', txt.InterpSamples);
fprintf(eid, 'CentralBody             %s\n', txt.CentralBody);
fprintf(eid, 'CoordinateSystem        %s\n', txt.CoordSystem);
fprintf(eid, 'BlockingFactor          %d\n', txt.BlockingFactor);
fprintf(eid, 'DistanceUnit            %s\n\n', txt.Units);

%% Create Time Position Velocity Section:
fprintf(eid, 'EphemerisLLATimePosVel\n\n');

for i = 1:NumPoints;
    fprintf(eid, '%.12e %.12e %.12e %.12e %.12e %.12e %.12e\n', ...
        vecClock(i), vecLat(i), vecLon(i), ...
        vecAlt(i), vecLatD(i), vecLonD(i), vecAltD(i));
end

fprintf(eid, '\n\nEND Ephemeris\n\n');
fclose(eid);

disp(' ')
nowStr = [datestr(now, 'dddd, mmmm') datestr(now,' dd, yyyy @ HH:MM:SS PM')];
disp(['New Emphemeris File Created: ' char(EphemerisFilename) ' {' nowStr '}']);

%% ========================================================================
%                           CREATE ATTITUDE FILE
%% ========================================================================
delete(AttitudeFilename);
aid = fopen(AttitudeFilename, 'w');

%% Create Header Information
fprintf(aid, '%s\n\n', txt.STK_version);
fprintf(aid, 'BEGIN Attitude\n\n');
fprintf(aid, 'NumberOfAttitudePoints %.0f\n', NumPoints);
fprintf(aid, 'BlockingFactor          %d\n', txt.BlockingFactor);
fprintf(aid, 'InterpolationOrder     %d\n', txt.InterpOrder);
fprintf(aid, 'CentralBody             %s\n', txt.CentralBody);
fprintf(aid, 'ScenarioEpoch           %s\n', EpochStrSTK);
fprintf(aid, 'CoordinateAxes        %s\n\n', txt.CoordAxes);

%% Create Time Orientation Section:
fprintf(eid, 'AttitudeTimeQuaternions\n');

for i = 1:NumPoints;
    fprintf(aid, '%.12e %.12e %.12e %.12e %.12e\n', ...
        vecClock(i), vecQ1(i), vecQ2(i), vecQ3(i), vecQ4(i));
end

fprintf(aid, '\n\nEND Attitude\n\n');
fclose(aid);
nowStr = [datestr(now, 'dddd, mmmm') datestr(now,' dd, yyyy @ HH:MM:SS PM')];
disp(['New Attitude File Created:   ' char(AttitudeFilename) ' {' nowStr '}']);
warning on MATLAB:DELETE:FileNotFound;

%% Compile Outputs:
%	= -1;

end % << End of function SaveSTK >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
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
