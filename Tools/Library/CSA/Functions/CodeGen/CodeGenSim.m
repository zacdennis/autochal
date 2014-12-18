% CODEGENSIM Auto-codes Simulink Model and constructs RTCF files
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CodeGenSim:
%   Autocodes a list of Simulink models, constructs the RTCF wrappers, and
%   builds sample data recorder (.ebs) files.
%
%   This is the top-level function for RTCF autocode.  It calls the
%   following CSA support functions: format_varargin, RTW_config, 
%   CreateParamFile, Write_RTCF_Wrapper, copyfiles
%
% SYNTAX:
%	lstFiles = CodeGenSim(lstSimName, varargin, 'PropertyName', PropertyValue)
%	lstFiles = CodeGenSim(lstSimName, varargin)
%	lstFiles = CodeGenSim(lstSimName)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	lstSimName	{ n x 3 }               List of Models to Code where...
%    (:, 1)     'string'    [char]      Name of Simulink model to autocode
%    (:, 2)     'string'    [char]      Relative path off of
%                                        'RootCodeFolder' in which to copy 
%                                        autocode
%    (:, 3)     'string'    [char]      ('BinFolder') Relative path off of
%                                        'RootCodeFolder' in which to place
%                                        the RTCF .dll component
%    (:, 4)     'string'    [char]      ('ScriptsFolder') Relative path off
%                                        of 'BinFolder' in which to place
%                                        RTCF initialization & test scripts
%    (:, 5)     'string'    [char]      ('RTDRFolder') Relative path off of
%                                        'BinFolder' in which to place RTCF
%                                        Real Time data recorder (RTDR)
%                                        scripts
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	lstFiles    { m x 1 }   {'string'}  List of files created
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName            PropertyValue   Default	Description
%   'RootCodeFolder'        'string'        pwd     Reference top-level 
%                                                    folder from which all
%                                                    RTCF folders are
%                                                    determined
%   'BuildModels'           [bool]          true        Build the models
%                                                    with MATLAB RTW?
%   'WriteWrappers'         [bool]          true        Build the RTCF
%                                                    wrappers?
%   'WriteCodeCheckHarness' [bool]          true    Build the autocode code
%                                                    check harness?
%   'Verbose'               [bool]          true    Show progress in
%                                                    Command Window?
%   'ClearSharedUtils'      [bool]          true    0: Use diary to
%                                                       determine the 
%                                                       shared utilities
%                                                  (1):Use dir_list
%
% EXAMPLES:
%	Build the Autocode for the Air Data Application
%   
%   RootCodeFolder = 'C:\Projects\ADA';
%   lstSimName      = {'ADA'   'ADA\Code'    'bin\scripts'};
%   flgBuildModels   = 1;   % Call rtw?
%   flgWriteWrappers = 1;   % Write RTCF wrappers?
%   SharedUtils = 'C:\Projects\ADA\Shared\Matlab';
%   UsePointers = true;
%
%   CodeGenSim(lstSimName, 'MarkingsFile', MarkingsFile, ...
%       'RootCodeFolder', RootCodeFolder, ...
%       'BuildModels', flgBuildModels, ...
%       'WriteWrappers', flgWriteWrappers, ...
%       'SharedUtilsFolder', SharedUtils);
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CodeGenSim.m">CodeGenSim.m</a>
%	  Driver script: <a href="matlab:edit Driver_CodeGenSim.m">Driver_CodeGenSim.m</a>
%	  Documentation: <a href="matlab:pptOpen('CodeGenSim_Function_Documentation.pptx');">CodeGenSim_Function_Documentation.pptx</a>
%
% See also format_varargin, RTW_config, CreateParamFile, Write_RTCF_Wrapper, copyfiles
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/620
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CodeGen/CodeGenSim.m $
% $Rev: 2636 $
% $Date: 2012-11-07 19:17:39 -0600 (Wed, 07 Nov 2012) $
% $Author: sufanmi $

function lstFiles = CodeGenSim(lstSimName, varargin)

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
lstFiles = {};

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[RootCodeFolder, varargin]          = format_varargin('RootCodeFolder', pwd, 2, varargin);
[flgBuildModels, varargin]          = format_varargin('BuildModels', true, 2, varargin);
[flgWriteWrappers, varargin]        = format_varargin('WriteWrappers', true, 2, varargin);
[flgWriteCodeCheckHarness, varargin]= format_varargin('WriteCodeCheckHarness', true, 2, varargin);
[flgVerbose, varargin]              = format_varargin('Verbose', 1, 0, varargin);
[flgClearSharedUtils, varargin]     = format_varargin('ClearSharedUtils', 1, 0, varargin);

%% Main Function:
[numModels, numCols] = size(lstSimName);
for iModel = 1:numModels
    % Pick off name of Sim
    curModel = lstSimName{iModel,1};
    
    if(flgVerbose)
        disp(sprintf('%s : [%d/%d] Processing %s...', mfnam, iModel, numModels, curModel));
    end

    % Pick off name of folder in which to place the autocode
    % Relative to 'RootCodeFolder'
    if(numCols > 1)
        CCodeFolder = lstSimName{iModel, 2};
    else
        CCodeFolder = curModel;
    end
    
    % Pick off name of folder in which to place the RTCF component's .dll
    % Relative to 'RootCodeFolder'
    BinFolder = '';
    if(numCols > 2)
        BinFolder = lstSimName{iModel, 3};
    end
    
    % Pick off name of folder in which to place the RTCF test script for
    % the RTCF .dll component.  Relative to 'RootCodeFolder'.
    ScriptsFolder = '';
    if(numCols > 3)
        ScriptsFolder = lstSimName{iModel, 4};
    end
    
    % Pick off name of folder in which to place the RTCF data recorder
    % script(s) for the RTCF .dll component.  Relative to 'RootCodeFolder'.
    RTDRFolder = curModel;
    if(numCols > 4)
        RTDRFolder = lstSimName{iModel, 5};
    end

    %
    ptrSlash = findstr(curModel, '/');
    if(isempty(ptrSlash))
        root_sim = curModel;
        strModel = curModel;
    else
        root_sim = curModel(1:ptrSlash(1)-1);
        strModel = curModel(ptrSlash(end)+1:end);
    end
    
    TerminateSim(root_sim, flgVerbose);
    load_system(root_sim);
    
    buildInfo = RTW.getBuildDir(root_sim);
    
    % Figure out full 
    fldrAutocode = [buildInfo.BuildDirectory];
    buildInfo.RootBuildDirectory = fileparts(buildInfo.BuildDirectory);

    fldrModelRefBuildDir =  [buildInfo.RootBuildDirectory filesep buildInfo.ModelRefRelativeBuildDir];
    fldrAutoShareUtils = [buildInfo.RootBuildDirectory filesep ...
        strrep(buildInfo.ModelRefRelativeBuildDir, curModel, '_sharedutils')];

    if(flgBuildModels || flgWriteCodeCheckHarness)
        
        if(isdir(fldrAutocode))
            rmdir(fldrAutocode, 's');
            
            if(flgClearSharedUtils && isdir(fldrAutoShareUtils))
                rmdir(fldrAutoShareUtils, 's');
            end
        end
        
        if(isdir(fldrModelRefBuildDir))
            rmdir(fldrModelRefBuildDir, 's');
        end

        % Step 1: Set RTW Options
        %      a. New in 2012a - MATLAB will not let you run a model
        %      reference unless InlineParams is set to 'on'.  For RTCF code
        %      generation, we want InlineParams 'off'.  So this workaround
        %      will first record what the current Params are, set them to
        %      'off', run the autocoder, and then reset the params to
        %      whatever they initially were.
        refInlineParam = get_param(root_sim, 'InlineParams');
        RTW_config(root_sim);

        if(~flgClearSharedUtils)
            % Step 2: Build the Model
            % 2a: Turn on the Diary
            filename_diary = [strModel '_diary.txt'];
            warn_msg = 'MATLAB:DELETE:FileNotFound';
            warning('off', warn_msg);
            delete(which(filename_diary));
            warning('on', warn_msg);
            diary(filename_diary);
        end

        % 2b: Build it
        rtwbuild(curModel);
        
        set_param(root_sim, 'InlineParams', refInlineParam);
        
        % Step 2c: Figure out what Shared Utility files are needed:
        if(flgClearSharedUtils)
            lstSharedUtils = dir_list({'*.cpp';'*.h';'*.c'},0, 'Root', fldrAutoShareUtils);
        else
            diary off;
            [flgError, info, lstSharedUtils] = ParseDiaryForSharedUtils(filename_diary, fldrAutoShareUtils, ...
                'Location', buildInfo.BuildDirectory, varargin{:});
        end

        % Step 3: Create the Parameter file from the ert_main just created
        CreateParamFile(strModel, [strModel '_ert_rtw/ert_main.cpp']);
    end

    if(flgWriteCodeCheckHarness)
        lstFiles2add = Write_CodeCheck_Harness(curModel, lstSharedUtils, ...
            'SharedUtilsFldr', fldrAutoShareUtils, ...
            'AutocodeFldr', fldrAutocode, varargin{:});
        lstFiles = [lstFiles; lstFiles2add];
    end
    
    if(flgWriteWrappers)
        % Step 5: Write the other requisite RTCF files
        lstFiles2add = Write_RTCF_Wrapper(curModel, ...
            'RootCodeFolder', RootCodeFolder, ...
            'CCodeFolder', CCodeFolder, ...
            'BinFolder', BinFolder, ...
            'ScriptsFolder', ScriptsFolder, ...
            'RTDRFolder', RTDRFolder, ...
            varargin{:});
        lstFiles = [lstFiles; lstFiles2add];
    end
end

if(flgVerbose == 1)
    disp(sprintf('%s : Finished!', mfilename));
end

end % << End of function CodeGenSim >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110124 MWS: Created function using CreateNewFunc
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