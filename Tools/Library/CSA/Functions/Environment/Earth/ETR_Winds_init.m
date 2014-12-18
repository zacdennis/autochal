% ETR_WINDS_INIT wind initialization for use with CSA wind databases
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ETR_Winds_init:
%    Wind Initialization
%    For use with the CSA Wind databases
%    Modify this file for use with your simulation by choosing the wind
%    database to use.
% 
% SYNTAX:
%	[Winds] = ETR_Winds_init(EpochStart, varargin, 'PropertyName', PropertyValue)
%	[Winds] = ETR_Winds_init(EpochStart, varargin)
%	[Winds] = ETR_Winds_init(EpochStart)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	EpochStart	[1x7]		[See Notes] <description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	Winds	    Structure	<units>		Structure that contains wind speeds
%                                       and azimuth
%
% NOTES:
%	EpochStart array is in the following form:
%   [ year, month, day, hour, minute, second, longitude ]
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Winds] = ETR_Winds_init(EpochStart, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Winds] = ETR_Winds_init(EpochStart)
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
%	Source function: <a href="matlab:edit ETR_Winds_init.m">ETR_Winds_init.m</a>
%	  Driver script: <a href="matlab:edit Driver_ETR_Winds_init.m">Driver_ETR_Winds_init.m</a>
%	  Documentation: <a href="matlab:pptOpen('ETR_Winds_init_Function_Documentation.pptx');">ETR_Winds_init_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/376
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/ETR_Winds_init.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Winds] = ETR_Winds_init(EpochStart, varargin)

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
%Winds= -1;
%% Load the ETR Wind Database:
%   Winds are in METRIC
load ETR_Wind_Year.mat;
clear Winds

Winds.Altitude = ETR_Wind.altitude;

Winds.Enable = 0;       % 1 = ON ; 0 = OFF

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
%% User Defined Section:
% Choose the data to use to populate the Winds structure.
% Example Options include:
%   Choosing a specific set (iSetNum) within a specified month:
%       Winds.Speed   = ETR_Wind.jan.velocity(:, iSetNum);
%       Winds.Azimuth = ETR_Wind.jan.azimuth(:, iSetNum);
%   Choosing the worst case for a month:
%       Winds.Speed   = ETR_Wind.jan.worstcase.velocity;
%       Winds.Azimuth = ETR_Wind.jan.worstcase.azimuth;
%   Choosing the absoulte worst case for all months in the year:
%       Winds.Speed   = ETR_Wind.WorstCase.velocity;
%       Winds.Azimuth = ETR_Wind.WorstCase.azimuth;

switch EpochStart(2)
    case 1
        % January
        Winds.Dataset   = 'January - Worst Case';
        Winds.Speed     = ETR_Wind.jan.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.jan.worstcase.azimuth;
        
    case 2
        % February
        Winds.Dataset   = 'February - Worst Case';
        Winds.Speed     = ETR_Wind.feb.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.feb.worstcase.azimuth;
        
    case 3
        % March
        Winds.Dataset   = 'March - Worst Case';
        Winds.Speed     = ETR_Wind.mar.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.mar.worstcase.azimuth;
        
    case 4
        % April
        Winds.Dataset   = 'April - Worst Case';
        Winds.Speed     = ETR_Wind.apr.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.apr.worstcase.azimuth;
                
    case 5
        % May
        Winds.Dataset   = 'May - Worst Case';
        Winds.Speed     = ETR_Wind.may.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.may.worstcase.azimuth;
               
    case 6
        % June
        Winds.Dataset   = 'June - Worst Case';
        Winds.Speed     = ETR_Wind.jun.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.jun.worstcase.azimuth;
                
    case 7
        % July
        Winds.Dataset   = 'July - Worst Case';
        Winds.Speed     = ETR_Wind.jul.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.jul.worstcase.azimuth;
                
    case 8
        % August
        Winds.Dataset   = 'August - Worst Case';
        Winds.Speed     = ETR_Wind.aug.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.aug.worstcase.azimuth;
                
    case 9
        % September
        Winds.Dataset   = 'September - Worst Case';
        Winds.Speed     = ETR_Wind.sep.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.sep.worstcase.azimuth;
                
    case 10
        % October
        Winds.Dataset   = 'October - Worst Case';
        Winds.Speed     = ETR_Wind.oct.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.oct.worstcase.azimuth;
                
    case 11
        % November
        Winds.Dataset   = 'November - Worst Case';
        Winds.Speed     = ETR_Wind.nov.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.nov.worstcase.azimuth;
                
    case 12
        % December
        Winds.Dataset   = 'December - Worst Case';
        Winds.Speed     = ETR_Wind.dec.worstcase.velocity;
        Winds.Azimuth   = ETR_Wind.dec.worstcase.azimuth;
                
    otherwise
        disp('ERROR Month Not Recognized!');
end

% Winds.Speed   = ETR_Wind.WorstCase.velocity;
% Winds.Azimuth = ETR_Wind.WorstCase.azimuth;

if(1)
    %% Convert Winds to ENGLISH Units
    conversions;        % Load Unit Conversions
    Winds.Units     = 'ENGLISH';
    Winds.Altitude  = Winds.Altitude * C.M2FT;  % [ft]
    Winds.Speed     = Winds.Speed * C.M2FT;     % [ft/s]
end
    
clear ETR_Wind

%% Compile Outputs:
%	Winds= -1;

end % << End of function ETR_Winds_init >>

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
