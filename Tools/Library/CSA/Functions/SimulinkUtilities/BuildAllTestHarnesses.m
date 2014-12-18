% BUILDALLTESTHARNESSES finds Bus Objects and creates test harnesses
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildAllTestHarnesses:
%   Finds all Bus Objects (BOs) in the workspace and creates test harnesses
%   for each one. This function relies on the CreateTestHarness.m file
%   residing in the path.
% 
% SYNTAX:
%	[] = BuildAllTestHarnesses(directory, CreateLib, varargin, 'PropertyName', PropertyValue)
%	[] = BuildAllTestHarnesses(directory, CreateLib, varargin)
%	[] = BuildAllTestHarnesses(directory, CreateLib)
%	[] = BuildAllTestHarnesses(directory)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   directory   [string]                The directory name to create or change into
%                                        where all the test harnesses shall reside\
%   CreateLib   [bool]                  Optional flag to create a library to contain all
%                                        harnesses
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%   Creates all of the available harnesses with the following name style
% BO_BusName_harness.mdl and deposits them into directory specified
% If CreateLib is 1, creates a library of harnesses BOHarnessLib located in
% specified directory
%	    	         <size>		<units>		<Description> 
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
%	[] = BuildAllTestHarnesses(directory, CreateLib, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = BuildAllTestHarnesses(directory, CreateLib)
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
%	Source function: <a href="matlab:edit BuildAllTestHarnesses.m">BuildAllTestHarnesses.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildAllTestHarnesses.m">Driver_BuildAllTestHarnesses.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildAllTestHarnesses_Function_Documentation.pptx');">BuildAllTestHarnesses_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/525
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/BuildAllTestHarnesses.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = BuildAllTestHarnesses(directory, CreateLib, varargin)

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
%        CreateLib= ''; directory= ''; 
%       case 1
%        CreateLib= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(CreateLib))
%		CreateLib = -1;
%  end
%% Main Function:
%% Protect against dependencies:
if(isempty(which('CreateTestHarness')))
    disp('The CreateTestHarness.m function cannot be found.');
    return;
end

if nargin < 2
    CreateLib = 0;
end

%% Look through the workspace to collect Bus Objects

Wrkspce = evalin('base', 'whos');

for iW = 1:length(Wrkspce)
    if strcmp(Wrkspce(iW).class, 'Simulink.Bus');
        BusName{iW,1} = Wrkspce(iW).name;
    end
end

%% Create test harnesses for each bus object
if(exist('BusName', 'var'))
    %% Execute file in 'directory' folder or create it if it doesn't exist
    homedir = pwd;
    [currentdirlocation currentdirname] = fileparts(homedir);
    
    if (~exist(directory, 'dir') || strcmp(currentdirname, directory))
        mkdir(directory)
    end
    
    cd(directory);
    
    %% Create Library
    if(CreateLib)
        
        LibName = 'BOHarnessLib';
        
        % Spacing Control:
        BlockSize         = [125 75];   % [width height]
        LeftMargin        = 15;
        TopMargin         = 15;
        VerticalSpacing   = 105;
        HorizontalSpacing = 170;
        
        if(exist(LibName,'file'))
            open_system(LibName);
            save_system(LibName, [LibName '_old']);
            close_system([LibName '_old.mdl'], 0);
            evalin('base', ['!del ' LibName '.mdl']);
        end
        new_system(LibName, 'Library');
        open_system(LibName);
        set_param(LibName,'Location',[75 106 863 767]);
    end
    
    %% Loop through Each Bus Object
    for iElement = 1:length (BusName)
        DriverName = [cell2str(BusName(iElement)) '_harness'];
        stringeval = ['CreateTestHarness(' cell2str(BusName{iElement}) ', ''' DriverName ''');'];
        evalin('base', stringeval);
        
        if(CreateLib)     
            % Add Harness to Library
            add_block([DriverName '/' DriverName], ['BOHarnessLib/' DriverName])
            
            % Position the block:
            icol = ceil(iElement/6);
            irow = iElement-6*(icol-1);
            set_param(['BOHarnessLib/' DriverName], 'Position', ...
                [LeftMargin + HorizontalSpacing * (icol-1)...                     left edge
                (TopMargin + VerticalSpacing * (irow-1) + 10) ...                 top edge
                (LeftMargin + HorizontalSpacing * (icol-1) + BlockSize(1)) ...    right edge
                (TopMargin + VerticalSpacing * (irow-1) + BlockSize(2)) + 10]); % bottom edge
        end
        close_system(DriverName);
    end;
    
    if(CreateLib)
        save_system('BOHarnessLib');
        close_system('BOHarnessLib');
    end
    
    % Return to the original working directory
    cd(homedir);

else
    disp('No bus objects exist in the base workspace');
end


%% Compile Outputs:
%	= -1;

end % << End of function BuildAllTestHarnesses >>

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
