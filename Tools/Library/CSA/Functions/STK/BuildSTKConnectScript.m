% BUILDSTKCONNECTSCRIPT Initializes the STKConnect script for vehicles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildSTKConnectScript:
%     <Function Description> 
% 
% SYNTAX:
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder, varargin, 'PropertyName', PropertyValue)
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder, varargin)
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder)
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles)
%
% INPUTS: 
%	Name            	Size		Units		Description
%   lstVehicles:
%       Column 1: Name of Vehicle (e.g. 'Stage1' or 'OFW')
%       Column 2: Vehicle Type (e.g. 'Satellite' or 'Aircraft');
%
%	STKFolder	       <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            	Size		Units		Description
%	STKConnectScript	<size>		<units>		<Description> 
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
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder)
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
%	Source function: <a href="matlab:edit BuildSTKConnectScript.m">BuildSTKConnectScript.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildSTKConnectScript.m">Driver_BuildSTKConnectScript.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildSTKConnectScript_Function_Documentation.pptx');">BuildSTKConnectScript_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/551
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/STK/BuildSTKConnectScript.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [STKConnectScript] = BuildSTKConnectScript(lstVehicles, STKFolder, varargin)

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
% STKConnectScript= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        STKFolder= ''; lstVehicles= ''; 
%       case 1
%        STKFolder= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(STKFolder))
%		STKFolder = -1;
%  end
%% Main Function:
STKConnectScript = [STKFolder 'STKConnectScript.txt'];

if(ispc)
    slash = '\';
else
    slash = '/';
end
%% OPEN STKConnectScript:
fid = fopen(STKConnectScript, 'w');
% 
% % Add Header Information:
for iVeh = 1:size(lstVehicles,1)
    strVehicle = char(lstVehicles(iVeh, 1));
    strType    = char(lstVehicles(iVeh, 2));
    
    fprintf(fid, 'VO */%s/%s ReloadArticFile\n', strType, strVehicle);
    fprintf(fid, 'sleep 1\n');
end

for iVeh = 1:size(lstVehicles,1)
    strVehicle = char(lstVehicles(iVeh, 1));
    strType    = char(lstVehicles(iVeh, 2));
    
    fprintf(fid, 'SetAttitude */%s/%s File "%s%s%s.a"\n', strType, ...
        strVehicle, STKFolder, slash, strVehicle);
    fprintf(fid, 'sleep 1\n');
        fprintf(fid, 'SetState */%s/%s File "%s%s%s.e"\n', strType, ...
            strVehicle, STKFolder, slash, strVehicle);
    fprintf(fid, 'sleep 1\n');
end

fclose(fid);
%% Compile Outputs:
%	STKConnectScript= -1;

end % << End of function BuildSTKConnectScript >>

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
