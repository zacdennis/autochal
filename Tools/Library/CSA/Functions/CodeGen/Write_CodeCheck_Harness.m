% WRITE_CODECHECK_HARNESS Builds C Wrapper for Autocode Verification
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Write_CodeCheck_Harness:
%     This function builds the C++ solution with the test harness for
%     testing a newly autocoded Simulink block or model.
%
% SYNTAX:
%	[lstFiles] = Write_CodeCheck_Harness(strModel, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = Write_CodeCheck_Harness(strModel, varargin)
%	[lstFiles] = Write_CodeCheck_Harness(strModel)
%
% INPUTS:
%	Name    	Size		Units		Description
%	strModel	'string'    [char]      Name of Autocoded Simulink block or
%                                        model
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	lstFiles	{'string'}  [char]      List of files created by function
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
%	[lstFiles] = Write_CodeCheck_Harness(strModel, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Write_CodeCheck_Harness.m">Write_CodeCheck_Harness.m</a>
%	  Driver script: <a href="matlab:edit Driver_Write_CodeCheck_Harness.m">Driver_Write_CodeCheck_Harness.m</a>
%	  Documentation: <a href="matlab:pptOpen('Write_CodeCheck_Harness_Function_Documentation.pptx');">Write_CodeCheck_Harness_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/696
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstFiles] = Write_CodeCheck_Harness(curModel, lstSharedUtilities, varargin)

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
lstFiles= '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]        = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
% [RootCodeFolder, varargin]      = format_varargin('RootCodeFolder', pwd,  2, varargin);
[CodeCheckRoot, varargin]       = format_varargin('CodeCheckRoot', [pwd filesep 'CodeCheck_' curModel],  2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', 1, 0, varargin);
[strExt, varargin]              = format_varargin('FileFormat', '.cpp',  2, varargin);
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  0, varargin);
[lstSharedUtils, varargin]      = format_varargin('SharedUtils', {},  2, varargin);
[fldrAutoShareUtils, varargin]  = format_varargin('SharedUtilsFldr', '',  2, varargin);
[fldrAutocode, varargin]        = format_varargin('AutocodeFldr', '',  2, varargin);

buildInfo = RTW.getBuildDir(curModel);
if(isempty(fldrAutocode))
    fldrAutocode = [buildInfo.BuildDirectory];
end

if(isempty(fldrAutoShareUtils))
    fldrModelRefBuildDir =  [buildInfo.RootBuildDirectory filesep buildInfo.ModelRefRelativeBuildDir];
    fldrAutoShareUtils = strrep(fldrModelRefBuildDir, curModel, '_sharedutils');
end

%% Compile Outputs:
% Create Code Check Folder:
if(~isdir(CodeCheckRoot))
    mkdir(CodeCheckRoot);
end

%% Step 1: Develop the Executable:
%  This is the Model.exe test harness
ExecutableFolder = [CodeCheckRoot filesep 'Executable'];

% Step 1: Clear contents of the exectuable folder:
if(isdir(ExecutableFolder))
    if(onpath(ExecutableFolder))
        rmpath(ExecutableFolder);
    end
    rmdir(ExecutableFolder, 's');
else
    mkdir(ExecutableFolder);
end

% Step 2: Compile List of all code generated files and copy them into the
% 'ExecutableFolder':
lstFilesToCopy = {};

% lstFilesToCopy = dir_list(, 1, 'Root', fldrAutoShareUtils);

if(isempty(lstSharedUtils))
    lstSharedUtils = dir_list({'*.c';'*.cpp'},1,'Root',fldrAutoShareUtils);
    for i = 1:size(lstSharedUtils, 1)
        curFile = lstSharedUtils{i,:};
        curFile = strrep(curFile, [fldrAutoShareUtils filesep], '');
        lstSharedUtils(i,:) = {curFile};
%         curFile = strrep(curFile, '.cpp', '*');
%         curFile = strrep(curFile, '.c', '*');
%         lstSharedUtils = [lstFilesToCopy; lstFiles]; %#ok<AGROW>
    end
end

% for i = 1:size(lstSharedUtils, 1)
%     curFile = lstSharedUtils{i,:};
%     curFile = strrep(curFile, '.cpp', '*');
%     curFile = strrep(curFile, '.c', '*');
%     lstFiles = dir_list(curFile, 1, 'Root', fldrAutoShareUtils);
%     lstFilesToCopy = [lstFilesToCopy; lstFiles]; %#ok<AGROW>
% end
lstFilesToCopy = dir_list({'*.c';'*.cpp';'*.h'},1,'Root',fldrAutoShareUtils);
% lstFiles = dir_list('rtw*.h', 1, 'Root', fldrAutoShareUtils);
% lstFilesToCopy = [lstFilesToCopy; lstFiles]; %#ok<AGROW>

lstModelFiles = dir_list({'*.c';'*.cpp';'*.h'},1,'Root',fldrAutocode, ...
    'FileExclude', 'ert_main.cpp');

lstFilesToCopy = [lstFilesToCopy; lstModelFiles]; %#ok<AGROW>

copyfiles(lstFilesToCopy, ExecutableFolder, 'CollapseFolders', 1);

% Step 3: Write the actual test harness (.cpp) that checks the code:
lstFiles = Write_CodeCheck_cpp(curModel, 'SaveFolder', ExecutableFolder, varargin{:});

lstSharedUtils = dir_list({'*.c';'*.cpp'},0,'Root',ExecutableFolder);

% Step 4: Write the .vcproj/.sln file for the Code Check executable:
[filename] = Write_CodeCheck_vcproj(curModel, lstSharedUtils, 'SaveFolder', ExecutableFolder, varargin{:});

% Step 5: Write the .bat file that can be used to build the .sln and
% then run it to build the solution:
[filename] = Write_MS_Studio_bat([ExecutableFolder filesep filename], varargin{:});

% Step 6: Write the MATLAB script that can run the CodeCheck executable for
% a bunch of different test cases:
% Write the Master .m file:
[filename] = Write_CodeCheck_Verify(curModel, 'SaveFolder', CodeCheckRoot, varargin{:});

end % << End of function Write_CodeCheck_Harness >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110512 MWS: Created function using CreateNewFunc
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
