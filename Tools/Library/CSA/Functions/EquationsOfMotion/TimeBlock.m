% TIMEBLOCK computes a TimeBus from mission time and an epoch.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% TimeBlock:
%   Computes Julian Date, Julian Centuries, GPS Time, and Greenwich Mean
%   Sidereal time from mission time and an epoch.
% 
% SYNTAX:
%	[TimeBus] = TimeBlock(simtime, Time)
%
% INPUTS: 
%	Name                Size	Units           Description
%   simtime             [1x1]   [sec]           Simulation Time
%   Time              	 [structure]            Simulation Time Structure
%   .EpochStart     	[1x6] 	[year mo. day   Simulation Epoch
%                                hour min sec]                
%   .GPSTimeDifference 	[1x1]   [sec]           Difference between GPS and 
%                                               real time
%
% OUTPUTS: 
%	Name                Size	Units           Description
%   TimeBus              [structure]            Time Structure
%   .simtime            [1x1]   [sec]           Simulation Time
%   .CommonDate         [1x6]   [year mo. day   Epoch adjusted for simtime
%                                hour min sec]
%   .GPSTime            [1x6]   [year mo. day   GPS Time
%                                hour min sec]           
%   .JulianDate         [1x1]   [day]           Julian Date
%   .JulianCenturies    [1x1]   [century]       Julian Centuries
%   .GMST_sec           [1x1]   [sec]           Greenwich Mean SiderealTime
%   .GMST               [1x1]   [deg]           Greenwich Mean SiderealTime
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
%	[TimeBus] = TimeBlock(simtime, Time, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[TimeBus] = TimeBlock(simtime, Time)
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
%	Source function: <a href="matlab:edit TimeBlock.m">TimeBlock.m</a>
%	  Driver script: <a href="matlab:edit Driver_TimeBlock.m">Driver_TimeBlock.m</a>
%	  Documentation: <a href="matlab:pptOpen('TimeBlock_Function_Documentation.pptx');">TimeBlock_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/398
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/TimeBlock.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [TimeBus] = TimeBlock(simtime, Time)

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
TimeBus= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Time= ''; simtime= ''; 
%       case 1
%        Time= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(Time))
%		Time = -1;
%  end
%% Main Function:
%% Simtime, [sec]:
TimeBus.simtime = simtime;

%% Common Date:
TimeBus.CommonDate = Time.EpochStart(1:6);
TimeBus.CommonDate(6) = TimeBus.CommonDate(6) + TimeBus.simtime;

%% GPS Time:
TimeBus.GPSTime     = TimeBus.CommonDate;
TimeBus.GPSTime(6)  = TimeBus.GPSTime(6) + Time.GPSTimeDifference;

%% JulianDate:
year    = TimeBus.CommonDate(1);    % [int]     Year
month   = TimeBus.CommonDate(2);    % [int]     Month
day     = TimeBus.CommonDate(3);    % [int]     Day
hour    = TimeBus.CommonDate(4);    % [int]     Hour
minute  = TimeBus.CommonDate(5);    % [int]     Minute
second  = TimeBus.CommonDate(6);    % [double]  Second

% Julian Date [day]:
TimeBus.JulianDate = (367 * year) ...
    - floor(7/4 * (year + floor( (month+9)/12 ))) ...
    + floor(275/9 * month) + day + 1721013.5 ...
    + (((second/60 + minute)/60) + hour) / 24;

% Julian Centuries:
TimeBus.JulianCenturies = (TimeBus.JulianDate - 2451545) / 36525;

%% Greenwich Mean Sidereal Time, [sec]:
TimeBus.GMST_sec = 67310.54841 ...
    + ( 3.164400184812866e9 * TimeBus.JulianCenturies ) ...
    + ( 0.093104 * TimeBus.JulianCenturies^2 ) ...
    - (6.2e-6 * TimeBus.JulianCenturies^3);
%   Convert to degrees:
TimeBus.GMST = mod(TimeBus.GMST_sec, 86400)/240;
%% Compile Outputs:
%	TimeBus= -1;

end % << End of function TimeBlock >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
