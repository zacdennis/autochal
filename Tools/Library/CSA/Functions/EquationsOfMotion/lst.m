% LST Calculate Mean Local Sidereal Time
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lst:
%    Calculate Mean Local Sidereal Time
%    LocalSiderealTime = LST( EpochStart ) where
%    EpochStart = [ year, month, day, hour, minute, second, longitude ]
%    Inputs the Epoch in year, month, days, hours, seconds and the local
%    longitude (deg) to compute the mean local sidereal time in degrees.
%    Use lon = 0 to compute the Greenwich MST. For the epoch chosen, this is
%    the Right Ascension (RA) or celestial longitude. Another way of looking
%    at this angle is to think of it as the angle of rotation between ECI and
%    ECEF in the earth spin direction.
%    East longitudes are positive
%    West longitudes are negative
% 
% SYNTAX:
%	[LocalSiderealTime] = lst(EpochStart)
%
% INPUTS: 
%	Name                Size	Units               Description
%   EpochStart          [1x7]   [year,month,        Epoch
%                               day,hour,minute,
%                               second,longitude]
%
% OUTPUTS: 
%	Name             	Size	Units               Description
%   LocalSiderealTime   [1x1]   [deg]               Mean local sidereal time
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
%	[LocalSiderealTime] = lst(EpochStart, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[LocalSiderealTime] = lst(EpochStart)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%     (Ref. Calculating Sidereal Time, Stephen R. Schmitt.)
%       (http://home.att.net/~srschmitt/siderealtime.html)
%
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
%	Source function: <a href="matlab:edit lst.m">lst.m</a>
%	  Driver script: <a href="matlab:edit Driver_lst.m">Driver_lst.m</a>
%	  Documentation: <a href="matlab:pptOpen('lst_Function_Documentation.pptx');">lst_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/392
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/lst.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [LocalSiderealTime] = lst(EpochStart)

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
LocalSiderealTime= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        EpochStart= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
%% Break up Input Vector
year    = EpochStart(1);
month   = EpochStart(2);
day     = EpochStart(3);
hour    = EpochStart(4);
minute  = EpochStart(5);
second  = EpochStart(6);
lon     = EpochStart(7);   %deg

    if month == 1 || month == 2
        year = year - 1;
        month = month + 12;
    end

    a = floor( year/100 );
    b = 2 - a + floor( a/4 );
    c = floor( 365.25*year );
    d = floor( 30.6001*( month + 1 ) );

    % days since J2000.0
    jd = b + c + d - 730550.5 + day + (hour + minute/60.0 + second/3600.0)/24.0;
    
    % julian centuries since J2000.0
    jt = jd/36525.0;

    % mean sidereal time
    mst = 280.46061837 + 360.98564736629*jd + 0.000387933*jt*jt - jt*jt*jt/38710000 + lon;

    if mst > 0.0
        while mst > 360.0
            mst = mst - 360.0;
        end
    else
        while mst < 0.0
            mst = mst + 360.0;
        end
    end
       
    LocalSiderealTime = mst;

%% Compile Outputs:
%	LocalSiderealTime= -1;

end % << End of function lst >>

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
