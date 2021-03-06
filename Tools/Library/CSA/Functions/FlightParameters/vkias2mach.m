% VKIAS2MACH Converts Mach Number to Indicated Airspeed assuming Std Atm
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vkias2mach:
%     Converts Mach Number to Indicated Airspeed assuming Standard
%     Atmosphere
% 
% SYNTAX:
%	[Mach] = vkias2mach(Vkias, Alt, varargin, 'PropertyName', PropertyValue)
%	[Mach] = vkias2mach(Vkias, Alt, varargin)
%	[Mach] = vkias2mach(Vkias, Alt)
%	[Mach] = vkias2mach(Vkias)
%
% INPUTS: 
%	Name        Size        Units		Description
%   Vkias       [1x1]       [knots]     Indicated Airspeed (vkias)
%   Alt         [1x1]       [ft]        Altitude
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   Mach        [1x1]       [ND]        Mach Number
%
% NOTES:
%   Function Uses Coesa1976.m
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[Mach] = vkias2mach(Vkias, Alt, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Mach] = vkias2mach(Vkias, Alt)
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
%	Source function: <a href="matlab:edit vkias2mach.m">vkias2mach.m</a>
%	  Driver script: <a href="matlab:edit Driver_vkias2mach.m">Driver_vkias2mach.m</a>
%	  Documentation: <a href="matlab:pptOpen('vkias2mach_Function_Documentation.pptx');">vkias2mach_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/365
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/FlightParameters/vkias2mach.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Mach] = vkias2mach(Vkias, Alt, varargin)

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
% Mach= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Alt= ''; Vkias= ''; 
%       case 1
%        Alt= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(Alt))
%		Alt = -1;
%  end
%% Main Function:
%% Load Unit Conversions
conversions;        

Vktas = vias2vtas(Vkias, Alt);  % [kts]
Mach  = vkts2mach(Vktas, Alt);  % [kts]


%% Compile Outputs:
%	Mach= -1;

end % << End of function vkias2mach >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
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
