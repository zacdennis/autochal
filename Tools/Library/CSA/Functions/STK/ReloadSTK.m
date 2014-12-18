% RELOADSTK Reloads a specified STK file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ReloadSTK:
%     <Function Description> 
% 
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "status" is a
% * function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType, varargin, 'PropertyName', PropertyValue)
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType, varargin)
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType)
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle)
%
% INPUTS: 
%	Name             	Size		Units		Description
%	filenameScenario	 <size>		<units>		<Description>
%	sourceFolder	     <size>		<units>		<Description>
%	strSTKVehicle	    <size>		<units>		<Description>
%	strSTKVehicleType	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name             	Size		Units		Description
%	status	           <size>		<units>		<Description> 
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
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType)
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
%	Source function: <a href="matlab:edit ReloadSTK.m">ReloadSTK.m</a>
%	  Driver script: <a href="matlab:edit Driver_ReloadSTK.m">Driver_ReloadSTK.m</a>
%	  Documentation: <a href="matlab:pptOpen('ReloadSTK_Function_Documentation.pptx');">ReloadSTK_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/553
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/STK/ReloadSTK.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [status] = ReloadSTK(filenameScenario, sourceFolder, strSTKVehicle, strSTKVehicleType, varargin)

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
% status= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        strSTKVehicleType= ''; strSTKVehicle= ''; sourceFolder= ''; filenameScenario= ''; 
%       case 1
%        strSTKVehicleType= ''; strSTKVehicle= ''; sourceFolder= ''; 
%       case 2
%        strSTKVehicleType= ''; strSTKVehicle= ''; 
%       case 3
%        strSTKVehicleType= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(strSTKVehicleType))
%		strSTKVehicleType = -1;
%  end
%% Main Function:
% Retrieve short name of Scenario folder:
[STKFolder, name, ext] = fileparts(filenameScenario);
STKFolder = [STKFolder filesep];

% Determine Articulation Extension Type
switch strSTKVehicleType
    case 'Aircraft'
        extArt = 'acma';
    case 'Satellite'
        extArt = 'sama';
    otherwise
end

% List of Vehicle Files to relocate to STKFolder
lstFiles{1,:} = [strSTKVehicle '.e'];
lstFiles{2,:} = [strSTKVehicle '.a'];
lstFiles{3,:} = [strSTKVehicle '.' extArt];

% Move files to STK Scenario Folder
for iFile = 1:size(lstFiles,1);
    curFile = char(lstFiles(iFile, :));
    if(exist([STKFolder curFile]) ~= 0)
        delete([STKFolder curFile]);
    end
    flgSuccess = copyfile([sourceFolder filesep curFile], ...
        [STKFolder curFile]);
end

% Reload / Refresh STK Scenario
lstVehicles{1,1} = strSTKVehicle;
lstVehicles{1,2} = strSTKVehicleType;
STKConnectScript = BuildSTKConnectScript(lstVehicles, STKFolder);
status = RefreshSTK(STKConnectScript);

% Show Status
disp(sprintf('%s : %s updated in %s', mfilename, strSTKVehicle, ...
    filenameScenario));

%% Compile Outputs:
%	status= -1;

end % << End of function ReloadSTK >>

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
