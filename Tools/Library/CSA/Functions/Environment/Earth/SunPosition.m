% SUNPOSITION Computes the Sun's Position in Earth Centered Inertial J2000
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SunPosition:
%   Computes the Sun's Position in Earth Centered Inertial J2000
%   Coordinates as well as the Right Ascension and Declination
% 
% SYNTAX:
%	[SunPositionBus] = SunPosition(JulianCenturies)
%
% INPUTS: 
%	Name           	Size	Units           Description
%	JulianCenturies	[1]     [centuries]     Julian Centuries (time
%                                           since ephemeris epoch of 2000
%
% OUTPUTS: 
%	Name                Size          Units		Description
%	SunPositionBus      {Structure}             Sun position structure
%    .P_i_AU            [3]           [AU]      Position vector
%    .P_i               [3]           [ft]      Position vector
%    .RightAscension    [1]           [rad]     Right Ascension
%    .Declination       [1]           [rad]     Declination  
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
%	[SunPositionBus] = SunPosition(JulianCenturies, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[SunPositionBus] = SunPosition(JulianCenturies)
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
%	Source function: <a href="matlab:edit SunPosition.m">SunPosition.m</a>
%	  Driver script: <a href="matlab:edit Driver_SunPosition.m">Driver_SunPosition.m</a>
%	  Documentation: <a href="matlab:pptOpen('SunPosition_Function_Documentation.pptx');">SunPosition_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/644
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/SunPosition.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [SunPositionBus] = SunPosition(JulianCenturies)

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
SunPositionBus= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        JulianCenturies= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
%% Load Conversions:
conversions; 

%% Mean Longitude of the Sun, LambdaM [deg]:
LambdaM = (280.4606184 + 36000.77005361 * JulianCenturies);

%% Mean Anomaly of the Sun, Msun [rad]:
Msun = (357.5277233 + 35999.05034 * JulianCenturies) * C.D2R;

%% Ecliptic LongitudeLambdaEcliptic
LambdaEcliptic = (LambdaM + 1.914666471*sin(Msun) + 0.019994643*sin(2*Msun)) * C.D2R;

%% Distance to the Sun, SunDistance [AU]:
SunDistance = 1.000140612 - 0.016708617*cos(Msun) - 0.000139589*cos(2*Msun);

%% Obliquity of the Ecliptic, Epsillon [rad]:
Epsillon = (23.439291 - 0.0130042 * JulianCenturies) * C.D2R;

%% Sun Position
%   Sun Position in Earth J2K inertial frame, [AU]:
SunPositionBus.P_i_AU(1)        = SunDistance * cos(LambdaEcliptic);
SunPositionBus.P_i_AU(2)        = SunDistance * sin(LambdaEcliptic) * cos(Epsillon);
SunPositionBus.P_i_AU(3)        = SunDistance * sin(LambdaEcliptic) * sin(Epsillon);
%   Sun Position in Earth J2K inertial frame, [feet]:
AU2FT = 490806662372.04724;
SunPositionBus.P_i              = SunPositionBus.P_i_AU * AU2FT;

%   Right Ascension [rad]:
SunPositionBus.RightAscension   = atan2( cos(Epsillon)*sin(LambdaEcliptic), cos(LambdaEcliptic) );
%   Declination [rad]:
SunPositionBus.Declination      = asin( sin(LambdaEcliptic)*sin(Epsillon) );

%% Compile Outputs:
%	SunPositionBus= -1;

end % << End of function SunPosition >>

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
